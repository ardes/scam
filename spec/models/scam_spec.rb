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
  it 'should set :parsed_content to {} when :content set' do
    @scam.should_receive(:parsed_content=).with({})
    @scam.content = 'Gday'
  end
end

describe Scam, '#to_<whatever> (without parsed_content[:whatever])' do
  before do
    @scam = Scam.new
    @scam.stub!(:parse).and_return('parsed')
  end
  
  it 'should respond to #to_whatever' do
    @scam.should respond_to(:to_whatever)
  end
  
  it 'should call #parse_whatever' do
    @scam.should_receive(:parse_whatever).once.and_return('parsed')
    @scam.to_whatever
  end
  
  it 'should call parse(:whatever) if #parse_whatever is not a method' do
    @scam.should_receive(:parse).with(:whatever).once.and_return('parsed')
    @scam.to_whatever
  end
  
  it 'should store the results of parse(:whetever) in parsed_content[:whatever] and save record' do
    @scam.should_receive(:save).once
    @scam.to_whatever
    @scam.parsed_content[:whatever].should == 'parsed'
  end
  
  it 'should raise NoMethodError if parse(:whatever) returns nil' do
    @scam.stub!(:parse).and_return(nil)
    lambda { @scam.to_whatever }.should raise_error(NoMethodError)
  end
end

describe Scam, '#to_<whatever> (with parsed_content[:whatever])' do
  before do
    @scam = Scam.new
    @scam.parsed_content[:whatever] = 'parsed'
  end

  it 'should return parsed_content[:whatever]' do
    @scam.to_whatever.should == 'parsed'
  end
  
  it 'should not save record' do
    @scam.should_not_receive(:save)
    @scam.to_whatever
  end
end

describe Scam, '.new' do
  before { @scam = Scam.new }
  
  it_should_behave_like 'Scam'
  
  it 'should return {} for #parsed_content' do
    @scam.parsed_content.should == {}
  end
  
  it 'should have default_content_type'
  
  it 'should call parse(default_content_type) whne #to_s called'
end