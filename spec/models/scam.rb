describe 'All Scams', :shared => true do
  it 'should set :parsed_content_cache to {} when :content set' do
    @scam.should_receive(:parsed_content_cache=).with({}).once
    @scam.content = 'Gday'
  end
  
  it '#to_s should call #parsed_content with no args' do
    @scam.should_receive(:parsed_content).once
    @scam.to_s
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