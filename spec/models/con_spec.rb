require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))
require File.expand_path(File.join(File.dirname(__FILE__), '../app'))

describe Con, ' class (migration helpers)' do
  it '#create_table should create cons table' do
    ActiveRecord::Base.connection.should_receive(:create_table).once.with('cons', {:opt => :foo})
    Con.create_table(:opt => :foo)
  end

  it '#drop_table should drop scam table' do
    ActiveRecord::Base.connection.should_receive(:drop_table).once.with('cons')
    Con.drop_table
  end
end