class Con < ActiveRecord::Base
  belongs_to :scam
  acts_as_tree :order => "#{table_name}.parent_id, #{table_name}.scam_id, #{table_name}.position"
  acts_as_list :scope => "#{table_name}.parent_id"
  
  # Rake migration task to create the con table
  def self.create_table(create_table_options = {})
    connection.create_table(table_name, create_table_options) do |t|
      t.integer :parent_id, :scam_id, :position
      t.string :type
      t.binary :content
      t.timestamps
    end
    
    connection.add_index table_name, :parent_id
    connection.add_index table_name, :scam_id
    connection.add_index table_name, :position
    connection.add_index table_name, :type
  end

  # Rake migration task to drop the con table
  def self.drop_table
    connection.drop_table table_name
  end
end