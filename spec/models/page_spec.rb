require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))
require File.expand_path(File.join(File.dirname(__FILE__), '../app'))

describe Page, "class (has_scams :content, :sidebar)" do
  it 'should have scam_names [:content, :sidebar]' do
    Page.scam_names.should == [:content, :sidebar]
  end
  
  it 'should have one :content and :sidebar Scam association' do
    Page.reflect_on_association(:content).macro.should == :has_one
    Page.reflect_on_association(:content).klass.should == Scam
    Page.reflect_on_association(:sidebar).macro.should == :has_one
    Page.reflect_on_association(:sidebar).klass.should == Scam
  end
end