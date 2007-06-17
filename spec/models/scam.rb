describe Scam, :shared => true do
  it 'should set :parsed_content to {} when :content set' do
    @scam.should_receive(:parsed_content=).with({})
    @scam.content = 'Gday'
  end
  
  it 'should call #to_content(:whatever) when sent #to_<whatever>' do
    @scam.should_receive(:to_content).with(:whatever).and_return('parsed')
    @scam.to_whatever
  end
  
  it 'should raise RuntimeError when sent #to_<whatever>, if parse_to(:whatever) returns nil' do
    @scam.stub!(:parse_to).and_return(nil)
    lambda { @scam.to_whatever }.should raise_error(RuntimeError)
  end
  
  it { @scam.should respond_to(:to_whatever) }
  
  it 'should call #to_content when sent #to_s' do
    @scam.should_receive(:to_content)
    @scam.to_s
  end
end