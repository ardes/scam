require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))
require File.expand_path(File.join(File.dirname(__FILE__), '../app'))
require File.expand_path(File.join(File.dirname(__FILE__), 'scam'))

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

describe Scam do
  before { @scam = Scam.new }
  
  it '#default_content_type should be :string' do
    @scam.default_content_type.should == :string
  end
  
  it { @scam.should respond_to(:to_string) }
  
  it { @scam.should_not respond_to(:to_whatever) }
  
  it_should_behave_like 'All Scams'

  it '#parsed_content(:whatever) should raise NoMethodError if #parse_to_whatever is not defined' do
    lambda { @scam.to_whatever }.should raise_error(NoMethodError)
  end
  
  it 'should return content.to_s with to_s' do
    @scam.content = 1
    @scam.to_s.should == '1'
  end
end

describe Scam, '.new (without scammable)' do
  before { @scam = Scam.new }
  
  it '#to_content(:whatever) should store result of parse BUT NOT save record' do
    @scam.stub!(:parse_to_whatever).and_return('parsed')
    @scam.should_not_receive(:save)
    @scam.parsed_content(:whatever)
    @scam.parsed_content_cache[:whatever].should == 'parsed'
  end
end

describe Scam, '.new (with scammable)' do
  before do
    @scammable = Product.create
    @scammable.scam = (@scam = Scam.new)
  end
  
  it_should_behave_like 'All Scams'

  it '#to_content(:whatever) should store the results of parse AND save record' do
    @scam.stub!(:parse_to_whatever).and_return('parsed')
    @scam.should_receive(:save)
    @scam.parsed_content(:whatever)
    @scam.parsed_content_cache[:whatever].should == 'parsed'
  end
end

describe Scam, ' with parsed_content_cache[:whatever]' do
  before do
    @scam = Scam.new
    @scam.parsed_content_cache[:whatever] = 'parsed'
  end
  
  it 'should return parsed_content[:whatever]' do
    @scam.parsed_content(:whatever).should == 'parsed'
  end

  it 'should not save record' do
    @scam.should_not_receive(:save)
    @scam.parsed_content(:whatever)
  end
end

describe Scam, ' existing, with parsed content cache' do
  before do
    s = Scam.new :name => :scam, :content => 'gday'
    s.parsed_content
    s.save
    @scam = Scam.find(s.id)
  end
  
  it '#parsed_content should not call #parse_to_string' do
    @scam.should_not_receive(:parse_to_string)
    @scam.parsed_content.should == 'gday'
  end
end
    
  