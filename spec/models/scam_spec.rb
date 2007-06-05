require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))
require File.expand_path(File.join(File.dirname(__FILE__), '../app'))
require File.expand_path(File.join(File.dirname(__FILE__), '../shared/scam'))

describe Scam, ' class' do
  before do
    @class = Scam
  end
  
  it_should_behave_like 'Scammer::Scam (migration helpers)'
end