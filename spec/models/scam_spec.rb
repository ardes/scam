require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))
require File.expand_path(File.join(File.dirname(__FILE__), '../app'))

describe Scam, ' class (migration helpers)' do
  it '#drop_table should drop scams table' do
    Scam.connection.should_receive(:drop_table).with('scams')
    Scam.drop_table
  end
  
  it '#create_table should create scams table and indexes' do
    Scam.connection.should_receive(:create_table).with('scams', {})
    Scam.connection.should_receive(:add_index).any_number_of_times
    Scam.create_table
  end
end

describe Scam, :shared => true do

end

describe Scam, '.new' do
  before { @scam = Scam.new }
  it_should_behave_like 'Scam'
  
#  it 'should have a real connection' do
#    puts Scam.connection.inspect
#  end
end