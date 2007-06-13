class Scam < ActiveRecord::Base
  belongs_to :scammable, :polymorphic => true
  
  validates_presence_of :name
  
  # Rake migration task to create the scam table
  def self.create_table(create_table_options = {})
    connection.create_table(table_name, create_table_options) do |t|
      t.integer :scammable_id
      t.string :type, :scammable_type, :name, :title
      t.text :content
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
  
  def content=(content)
    write_attribute(:content, to_content(content))
  end
  
  def name
    read_attribute(:name).to_sym rescue nil
  end
  
  def to_s
    self.content
  end
end

class MarukuScam < Scam
end