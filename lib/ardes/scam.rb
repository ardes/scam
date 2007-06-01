module Scammer
  mattr_accessor :scam_class_name
  self.scam_class_name = 'Scam'
  
  # extended into ActiveRecord, adds macros to associate any model with scam(s)
  module Scammable
    def self.extended(base)
      base.class_eval do
        class_inheritable_writer :scam_class_name
      end
    end
    
    def has_scam(*names)
      include InstanceMethods unless included_modules.include? Scammer::Scammable::InstanceMethods
      options = names.last.is_a?(Hash) ? names.pop : {}
      names = [:scam] if names.size == 0
      names.each {|name| add_scam(name.to_sym, options)}
    end
    
    alias_method :has_scams, :has_scam
      
    def scam_class_name
      read_inheritable_attribute(:scam_class_name) || write_inheritable_attribute(:scam_class_name, Scammer.scam_class_name)
    end

    module InstanceMethods
      def self.included(base)
        base.class_eval do
          extend ClassMethods
        end
      end
    end
    
    module ClassMethods
      def scam_names
        read_inheritable_attribute(:scam_names) || write_inheritable_attribute(:scam_names, [])
      end
      
    protected
      def add_scam(name, options = {})
        raise RuntimeError, "Scam #{name} is already declared" if scam_names.include? name
        scam_names << name
        has_one name, :as => :scammable, :class_name => (options[:class_name] || scam_class_name), :conditions => {:name => name}
      end
    end
  end
  
  # return the default Scam ActiveRecord class, create it if it doesn't exist
  def self.scam_class
    eval "::#{scam_class_name}"
  rescue
     returning Object.const_set(scam_class_name, Class.new(ActiveRecord::Base)) do |klass|
       klass.send :include, Scammer::Scam
     end
  end
  
  module Scam
    def self.included(base)
      base.class_eval do
        extend ClassMethods
        belongs_to :scammable, :polymorphic => true
      end
    end
    
    module ClassMethods
      # Rake migration task to create the change table
      def create_table(create_table_options = {})
        self.connection.create_table(table_name, create_table_options) do |t|
            t.column :type, :string
            t.column :scammable_id, :integer
            t.column :scammable_type, :string
            t.column :name, :string
            t.column :title, :string
            t.column :position, :integer
            t.column :created_at, :datetime
            t.column :updated_at, :datetime
          end
      end

      # Rake migration task to drop the change table
      def drop_table
        self.connection.drop_table table_name
      end
    end
  end
end