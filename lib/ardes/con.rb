class Con < ActiveRecord::Base
  belongs_to :scam
  acts_as_list :scope => "#{table_name}.scam_id"
  
  # Rake migration task to create the con table
  def self.create_table(create_table_options = {})
    self.connection.create_table(table_name, create_table_options) do |t|
        t.column :type, :string
        t.column :scam_id, :integer
        t.column :content, :binary
        t.column :position, :integer
        t.column :created_at, :datetime
        t.column :updated_at, :datetime
      end
  end

  # Rake migration task to drop the con table
  def self.drop_table
    self.connection.drop_table table_name
  end
end