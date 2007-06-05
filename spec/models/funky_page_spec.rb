require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))
require File.expand_path(File.join(File.dirname(__FILE__), '../app'))

describe FunkyPage, "class (< Page | has_scam :funk)" do
  it 'should have scam_names [:content, :sidebar, :funk, :normal]' do
    FunkyPage.scam_names.should == [:content, :sidebar, :funk]
  end

  it 'should have one :content, :sidebar, and :funk Scam association' do
    FunkyPage.reflect_on_association(:content).macro.should == :has_one
    FunkyPage.reflect_on_association(:content).klass.should == Scam
    FunkyPage.reflect_on_association(:sidebar).macro.should == :has_one
    FunkyPage.reflect_on_association(:sidebar).klass.should == Scam
    FunkyPage.reflect_on_association(:funk).macro.should == :has_one
    FunkyPage.reflect_on_association(:funk).klass.should == Scam
  end
end

