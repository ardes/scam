__DIR__ = File.expand_path(File.dirname(__FILE__))
require File.expand_path("#{__DIR__}/../spec_helper")
require File.expand_path("#{__DIR__}/../app")
require File.expand_path("#{__DIR__}/scam_shared")

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

describe Scam, ' parsing' do
  before { @scam = Scam.new }
  
  it '#to_<whatever> should call #parsed_content(:whatever)' do
    @scam.should_receive(:parsed_content).with(:whatever).once.and_return('parsed')
    @scam.to_whatever
  end
  
  it '#to_<whatever>(*args) should call #parsed_content(:whatever, *args)' do
    @scam.should_receive(:parsed_content).with(:whatever, :a, :b, :c).once.and_return('parsed')
    @scam.to_whatever(:a, :b, :c)
  end
  
  it 'when parsed_content_cache[:whatever] exists, #parsed_content(:whatever) should return caache, and not call #parse_to_whatever' do
    @scam.parsed_content_cache[:whatever] = 'cached'
    @scam.should_not_receive(:parse_to_whatever)
    @scam.parsed_content(:whatever).should == 'cached'
  end
  
  it 'when parsed_content_cache[[:whatever, *args]] exists, #parsed_content(:whatever, *args) cache, and not call #parse_to_whatever' do
    @scam.parsed_content_cache[[:whatever, :a, :b, :c]] = 'cached'
    @scam.should_not_receive(:parse_to_whatever)
    @scam.parsed_content(:whatever, :a, :b, :c).should == 'cached'
  end
end

describe Scam, ' parsing (when cache empty)' do
  before { @scam = Scam.new }
  
  it '#parsed_content(:whatever) should call #parse_to_whatever' do
    @scam.should_receive(:parse_to_whatever).once.and_return('parsed')
    @scam.parsed_content(:whatever)
  end

  it '#parsed_content(:whatever) should cache #parse_to_whatever as :whatever' do
    @scam.stub!(:parse_to_whatever).and_return('parsed')
    @scam.parsed_content_cache.should_receive(:[]=).with([:whatever, :a, :b, :c], 'parsed')
    @scam.parsed_content(:whatever, :a, :b, :c)
  end
  
  it '#parsed_content(:whatever, *args) should call #parse_to_whatever(*args)' do
    @scam.should_receive(:parse_to_whatever).with(:a, :b, :c).once.and_return('parsed')
    @scam.parsed_content(:whatever, :a, :b, :c)
  end
  
  it '#parsed_content(:whatever, *args) should cache #parse_to_whatever(*args) as [:whatever, *args]' do
    @scam.stub!(:parse_to_whatever).and_return('parsed')
    @scam.parsed_content_cache.should_receive(:[]=).with([:whatever, :a, :b, :c], 'parsed')
    @scam.parsed_content(:whatever, :a, :b, :c)
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
  
  it '#expire_cache should just remove parsed_content_cache without attempting save' do
    @scam.parsed_content_cache = {:stuff => 'stuff'}
    @scam.should_not_receive :save
    @scam.expire_cache
    @scam.parsed_content_cache.should == {}
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
  
  it '#expire_cache should remove the cache directly from the database' do
    @scam.expire_cache
    @scam.parsed_content_cache.should == {}
    Scam.find(@scam.id).parsed_content_cache.should == {}
  end
end
    
describe Scam, ' existing, with parsed content cahce, when Scam.cache_parsed_content = false' do
  before do
    s = Scam.new :name => :scam, :content => 'gday'
    s.parsed_content
    s.save
    @scam = Scam.find(s.id)
    Scam.cache_parsed_content = false
  end
  
  after do
    Scam.cache_parsed_content = true
  end
  
  it '#parsed_content should call #parse_to_string' do
    @scam.should_receive(:parse_to_string).and_return('parsed')
    @scam.parsed_content.should == 'parsed'
  end
end

describe Scam, '.expire_cache' do
  before do
    @s1 = Scam.new :name => :scam1, :content => 'gday'
    @s1.parsed_content
    @s1.save
    @s2 = Scam.new :name => :scam2, :content => 'foo'
    @s2.parsed_content
    @s2.save
  end
  
  it 'should remove the parsed_content_cache from every scam' do
    Scam.find(@s1.id).parsed_content_cache.should == {:string => "gday"}
    Scam.find(@s2.id).parsed_content_cache.should == {:string => 'foo'}
    Scam.expire_cache
    Scam.find(@s1.id).parsed_content_cache.should == {}
    Scam.find(@s2.id).parsed_content_cache.should == {}
  end
end