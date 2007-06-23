describe 'All Scams', :shared => true do
  it 'should set :parsed_content_cache to {} when :content set' do
    @scam.should_receive(:parsed_content_cache=).with({}).once
    @scam.content = 'Gday'
  end
  
  it '#to_<whatever> should call #parsed_content(:whatever)' do
    @scam.should_receive(:parsed_content).with(:whatever).once.and_return('parsed')
    @scam.to_whatever
  end
  
  it '#to_<whatever>(*args) should call #parsed_content(:whatever, *args)' do
    @scam.should_receive(:parsed_content).with(:whatever, :a, :b, :c).once.and_return('parsed')
    @scam.to_whatever(:a, :b, :c)
  end
  
  it '#to_s should call #parsed_content with no args' do
    @scam.should_receive(:parsed_content).once
    @scam.to_s
  end
  
  it '#parsed_content(:whatever) should call #parse_to_whatever, if there is no cache' do
    @scam.parsed_content_cache = {}
    @scam.should_receive(:parse_to_whatever).once.and_return('parsed')
    @scam.parsed_content(:whatever)
  end
  
  it '#parsed_content(:whatever, *args) should call #parse_to_whatever(*args), if there is no cache' do
    @scam.parsed_content_cache = {}
    @scam.should_receive(:parse_to_whatever).with(:a, :b, :c).once.and_return('parsed')
    @scam.parsed_content(:whatever, :a, :b, :c)
  end
  
  it '#parsed_content(:whatever) should return parsed_content_cache[:whatever], and not call #parse_to_whatever, if cache exists' do
    @scam.parsed_content_cache[:whatever] = 'cached'
    @scam.should_not_receive(:parse_to_whatever)
    @scam.parsed_content(:whatever).should == 'cached'
  end
  
  it '#parsed_content() should call #parse_to_<default_content_type>, if there is no cache' do
    @scam.parsed_content_cache = {}
    @scam.should_receive("parse_to_#{@scam.default_content_type}").once.and_return('parsed')
    @scam.parsed_content
  end

  it '#parsed_content() should return parsed_content_cache[default_content_type], and not call #parse_to_<default_content_type>, if cache exists' do
    @scam.parsed_content_cache[@scam.default_content_type] = 'cached'
    @scam.should_not_receive("parse_to_#{@scam.default_content_type}")
    @scam.parsed_content.should == 'cached'
  end
end