require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))

describe Ardes::Scammable, ' module' do
  it 'should have scam_class_name of "Scam"' do
    Ardes::Scammable.scam_class_name.should == "Scam"
  end
end
