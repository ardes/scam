require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))
require File.expand_path(File.join(File.dirname(__FILE__), '../app'))

describe Scam, ' class' do
  it 'should have many :cons' do
    Scam.reflect_on_association(:cons).macro.should == :has_many
  end
end

describe Scam, ' class (migration helpers)' do
  before do
    @connection = mock('connection')
    @connection.stub!(:create_table)
    @connection.stub!(:drop_table)
    @connection.stub!(:add_index)
    Scam.stub!(:connection).and_return(@connection)
  end
   
  it '#create_table should create scams table' do
    @connection.should_receive(:create_table).once.with('scams', {})
    Scam.create_table
  end
  
  it '#create_table shoudl create indexes for :type, :scammable_id, and :scammable_type' do
    @connection.should_receive(:add_index).with('scams', :type).once
    @connection.should_receive(:add_index).with('scams', :scammable_id).once
    @connection.should_receive(:add_index).with('scams', :scammable_type).once
    Scam.create_table
  end
  
  it '#drop_table should drop scams table' do
    @connection.should_receive(:drop_table).once.with('scams')
    Scam.drop_table
  end
end

