require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))

describe Scammable, ' module' do
  it 'should have scam_class_name of "Scam"' do
    Scammable.scam_class_name.should == "Scam"
  end
end
