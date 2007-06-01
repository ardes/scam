require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))
require File.expand_path(File.join(File.dirname(__FILE__), '../app'))
require File.expand_path(File.join(File.dirname(__FILE__), '../lib/scam'))

describe PageScam, ' class' do
  before do
    @class = PageScam
  end
  
  it_should_behave_like 'Scammer::Scam (migration helpers)'
end