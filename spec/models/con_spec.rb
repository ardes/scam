require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))
require File.expand_path(File.join(File.dirname(__FILE__), '../app'))

describe Con, ' class' do
  it 'should belong to :scam' do
    Con.reflect_on_association(:scam).macro.should == :belongs_to
  end
end

describe Con, ' class (migration helpers)' do
  before do
    @connection = mock('connection')
    @connection.stub!(:create_table)
    @connection.stub!(:drop_table)
    @connection.stub!(:add_index)
    Con.stub!(:connection).and_return(@connection)
  end
   
  it '#create_table should create cons table' do
    @connection.should_receive(:create_table).once.with('cons', {})
    Con.create_table
  end
  
  it '#create_table should create indexes for :type, :scam_id, :parent_id and :position' do
    @connection.should_receive(:add_index).with('cons', :type).once
    @connection.should_receive(:add_index).with('cons', :scam_id).once
    @connection.should_receive(:add_index).with('cons', :parent_id).once
    @connection.should_receive(:add_index).with('cons', :position).once
    Con.create_table
  end
  
  it '#drop_table should drop cons table' do
    @connection.should_receive(:drop_table).once.with('cons')
    Con.drop_table
  end
end
