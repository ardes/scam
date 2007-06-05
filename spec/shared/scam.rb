describe 'Scammer::Scam (migration helpers)', :shared => true do
  it '#create_table should create scam table' do
    ActiveRecord::Base.connection.should_receive(:create_table).once.with(@class.table_name, {:opts => :foo})
    @class.create_table(:opts => :foo)
  end
  
  it '#drop_table should drop scam table' do
    ActiveRecord::Base.connection.should_receive(:drop_table).once.with(@class.table_name)
    @class.drop_table
  end
end