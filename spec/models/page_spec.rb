__DIR__ = File.dirname(__FILE__)
require File.expand_path("#{__DIR__}/../spec_helper")
require File.expand_path("#{__DIR__}/../app")
require File.expand_path("#{__DIR__}/scam_association_shared")

describe Page, "class | scam_class_name = 'MarukuScam' | has_scams :content, :sidebar" do
  it 'should have scam_names [:content, :sidebar]' do
    Page.scam_names.should == [:content, :sidebar]
  end
  
  it 'should have one MarukuScam as :content' do
    Page.reflect_on_association(:content).macro.should == :has_one
    Page.reflect_on_association(:content).klass.should == MarukuScam
  end
  
  it 'should have one MarukuScam as :sidebar' do
    Page.reflect_on_association(:sidebar).macro.should == :has_one
    Page.reflect_on_association(:sidebar).klass.should == MarukuScam
  end
end

describe Page, ' :content association' do
  before { @scammable, @scam_name = Page.new, :content }
  
  it_should_behave_like 'Scam association'
end

describe Page, ' :sidebar association' do
  before { @scammable, @scam_name = Page.new, :sidebar }

  it_should_behave_like 'Scam association'
end