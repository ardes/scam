require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))
require File.expand_path(File.join(File.dirname(__FILE__), '../app'))
require File.expand_path(File.join(File.dirname(__FILE__), '../lib/scammable'))

describe Page, "(an ActiveRecord with has_scams :content, :sidebar)" do

end

describe Page, " :content association" do
  before do
    @assoc = Page.reflect_on_association(:content)
  end
  
  it_should_behave_like 'Scammer::Scammable scam association'
  
  it 'klass should be PageScam' do
    @assoc.klass.should == PageScam
  end
end

describe Page, " :sidebar association" do
  before do
    @assoc = Page.reflect_on_association(:sidebar)
  end
  
  it_should_behave_like 'Scammer::Scammable scam association'
  
  it 'klass should be PageScam' do
    @assoc.klass.should == PageScam
  end
end
