class Scam < ActiveRecord::Base
  class_inheritable_accessor :default_content_type
  
  belongs_to :scammable, :polymorphic => true
  
  serialize :parsed_content
  
  validates_presence_of :name
  
  # initialize parsed_content with {} on first read
  def parsed_content
    read_attribute(:parsed_content) || self.parsed_content = {}
  end
  
  # reset parsed_content when content written
  def content=(content)
    self.parsed_content = {}
    write_attribute(:content, content)
  end
  
  # name is a symbol
  def name
    read_attribute(:name).to_sym rescue nil
  end
      
  def method_missing(method, *args, &block)
    if method.to_s =~ /^to_(.+)$/
      content_type = $1.to_sym
      returning(to_content(content_type)) do |parsed|
        raise RuntimeError, "Unknown content type #{content_type}" unless parsed
      end
    else
      super
    end
  end

  def respond_to?(method)
    super || method.to_s =~ /^to_.+$/
  end
  
  def to_content(content_type = self.default_content_type)
    content_type = content_type.to_sym if content_type.is_a?(String)
    return parsed_content[content_type] if parsed_content[content_type]
    parsed = content_type ? (send("parse_to_#{content_type}") rescue parse_to(content_type)) : parse_to(content_type)
    returning parsed do |parsed|
      update_attributes :parsed_content => self.parsed_content.merge(content_type => parsed)
    end
  end

  # Rake migration task to create the scam table
  def self.create_table(create_table_options = {})
    connection.create_table(table_name, create_table_options) do |t|
      t.integer :scammable_id
      t.string :type, :scammable_type, :name, :title
      t.text :content
      t.binary :parsed_content
      t.timestamps
      yeild(t) if block_given?
    end

    connection.add_index table_name, [:id, :type]
    connection.add_index table_name, [:scammable_id, :scammable_type, :name]
  end

  # Rake migration task to drop the scam table
  def self.drop_table
    connection.drop_table table_name
  end
  
protected
  def parse_to(content_type, content = self.content)
    content.to_s
  end
end

class MarukuScam < Scam
end