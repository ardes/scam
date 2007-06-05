class Scam < ActiveRecord::Base
  belongs_to :scammable, :polymorphic => true
  has_many :cons, :order => "#{table_name}.position"
  
  # Rake migration task to create the scam table
  def self.create_table(create_table_options = {})
    connection.create_table(table_name, create_table_options) do |t|
      t.integer :scammable_id
      t.string :type, :scammable_type, :name, :title
      t.timestamps
    end

    connection.add_index table_name, :type
    connection.add_index table_name, :scammable_id
    connection.add_index table_name, :scammable_type
  end

  # Rake migration task to drop the scam table
  def self.drop_table
    connection.drop_table table_name
  end
end