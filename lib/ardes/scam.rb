class Scam < ActiveRecord::Base
  belongs_to :scammable, :polymorphic => true
  
  serialize :parsed_content
  
  validates_presence_of :name
  
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
  
  # transform the passed object into a format suitable for content
  def self.to_content(content)
    content
  end
  
  def to_content(content)
    self.class.to_content(content)
  end
  
  def parsed_content
    read_attribute(:parsed_content) || self.parsed_content = {}
  end
  
  def content=(content)
    self.parsed_content = {}
    write_attribute(:content, to_content(content))
  end
  
  def name
    read_attribute(:name).to_sym rescue nil
  end
  
  def to_s
    self.content
  end
    
  def method_missing(method, *args, &block)
    if method.to_s =~ /^to_(.+)$/
      returning(to_parsed_content($1.to_sym)) {|p| raise NoMethodError unless p}
    else
      super
    end
  end

  def respond_to?(method)
    super || method.to_s =~ /^to_.+$/
  end
  
  def to_parsed_content(content_type)
    content_type = content_type.to_sym
    return parsed_content[content_type] if parsed_content[content_type]
      
    parsed = (send("parse_#{content_type}") rescue parse(content_type))
    returning parsed do |str|
      update_attributes :parsed_content => self.parsed_content.merge(content_type => str)
    end
  end
  
protected
  def parse(content_type, content = self.content)
    content.to_s
  end
end

class MarukuScam < Scam
end