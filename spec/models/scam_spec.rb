require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))
require File.expand_path(File.join(File.dirname(__FILE__), '../app'))

describe Scam, ' class (migration helpers)' do
  it '#create_table should create scams table' do
    ActiveRecord::Base.connection.should_receive(:create_table).once.with('scams', {:opts => :foo})
    Scam.create_table(:opts => :foo)
  end

  it '#drop_table should drop scams table' do
    ActiveRecord::Base.connection.should_receive(:drop_table).once.with('scams')
    Scam.drop_table
  end
end