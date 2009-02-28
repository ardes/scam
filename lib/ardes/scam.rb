module Ardes
  module Scam
    mattr_accessor :caching
    self.caching = true
  
    def self.included(base)
      base.class_eval do
        extend ClassMethods

        class_inheritable_accessor :default_content_type
        self.default_content_type = :string

        belongs_to :scammable, :polymorphic => true
        serialize :parsed_content_cache, Hash
        validates_presence_of :name

        delegate :default_content_type, :to => 'self.class'
      end
    end
  
    module ClassMethods
      # Rake migration task to create the scam table
      def create_table(create_table_options = {})
        connection.create_table(table_name, create_table_options) do |t|
          t.integer :scammable_id
          t.string :type, :scammable_type, :name, :title
          t.text :content
          t.binary :parsed_content_cache
          t.timestamps
          yeild(t) if block_given?
        end

        connection.add_index table_name, [:id, :type]
        connection.add_index table_name, [:scammable_id, :scammable_type, :name]
      end

      # Rake migration task to drop the scam table
      def drop_table
        connection.drop_table table_name
      end
    
      # directly removes all content caches from the database
      def expire_cache
        update_all ['parsed_content_cache = ?', {}] rescue nil
      end
    end
  
    # lazy initialize parsed_content_cache, so it can be used with abandon
    def parsed_content_cache
      unserialize_attribute('parsed_content_cache') || self.parsed_content_cache = {}
    end
  
    # reset parsed_content_cache when content written
    def content=(content)
      self.parsed_content_cache = {}
      write_attribute(:content, content)
    end
  
    # name is a symbol
    def name
      read_attribute(:name).to_sym rescue nil
    end
  
    def name=(a_name)
      write_attribute(:name, a_name.to_sym.to_s)
    end
      
    def method_missing(method, *args, &block)
      if method.to_s =~ /^to_(.+)$/
        parsed_content($1.to_sym, *args)
      else
        super
      end
    end

    def respond_to?(method)
      super || (method.to_s =~ /^to_(.+)$/ && (parsed_content_cache[$1.to_sym] || respond_to?("parse_to_#{$1}")))
    end
  
    # Returns the parsed content of specified type.  If it doesn't exist, then it is parsed.
    # If this scam has an existing scammable, the parsed content is saved (if it isn't
    # the the parsed content will be saved if and when the scammable is saved)
    def parsed_content(content_type = default_content_type, *args)
      return send("parse_to_#{content_type}", *args) unless self.class.caching
    
      content_type = content_type.to_sym
      key = (args.size == 0 ? content_type : [content_type, *args])
      return parsed_content_cache[key] if parsed_content_cache[key]
      returning send("parse_to_#{content_type}", *args) do |parsed|
        store_parsed_content(key, parsed)
      end
    end

    # directly removes the content cache from the database for this record if the record is saved
    def expire_cache
      self.class.update_all(['parsed_content_cache = ?', {}], ['id = ?', id]) unless new_record?
      self.parsed_content_cache = {}
    end
  
    def to_s
      parsed_content
    end
  
    # turn timestamping off in a threadsafe manner
    def without_timestamps(&block)
      metaclass.send(:define_method, :record_timestamps) { false }
      yield
    ensure
      metaclass.send(:remove_method, :record_timestamps)
    end
  
  protected
    def parse_to_string
      content.to_s
    end
  
    def store_parsed_content(key, parsed)
      self.parsed_content_cache[key] = parsed
      without_timestamps do
        save if scammable && !scammable.new_record?
      end
    end
  end
end