__DIR__ = File.expand_path(File.dirname(__FILE__))
require File.expand_path("#{__DIR__}/../spec_helper")

describe Ardes::Scammable, ' module' do
  it 'should have scam_class_name of "Scam"' do
    Ardes::Scammable.scam_class_name.should == "Scam"
  end
end
