require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))

describe Scammer, " creating scam class", :shared => true do  
  it '#scam_class should create class on demand' do
    (Object.send :remove_const, Scammer.scam_class_name rescue nil)
    Scammer.scam_class.should be_kind_of(Class)
  end
  
  it '#scam_class should be an ActiveRecord::Base' do
    Scammer.scam_class.ancestors.should include(ActiveRecord::Base)
  end
  
  it '#scam_class should be a Scammer::Scam' do
    Scammer.scam_class.ancestors.should include(Scammer::Scam)
  end
end

describe Scammer do
  it 'should have default scam_class_name of "Scam"' do
    Scammer.scam_class_name.should == 'Scam'
  end
  
  it_should_behave_like "Scammer creating scam class"
end

describe Scammer, " (with scam_class_name = 'FooScam')" do
  before(:all) do
    @saved_name = Scammer.scam_class_name
    Scammer.scam_class_name = 'FooScam'
  end
  
  it_should_behave_like "Scammer creating scam class"

  after(:all) do
    Scammer.scam_class_name = @saved_name
  end
end
