class Scam < ActiveRecord::Base
  belongs_to :scammable, :polymorphic => true
  has_many :cons, :order => "#{table_name}.position"
  
  # Rake migration task to create the scam table
  def self.create_table(create_table_options = {})
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

  # Rake migration task to drop the scam table
  def self.drop_table
    self.connection.drop_table table_name
  end
end