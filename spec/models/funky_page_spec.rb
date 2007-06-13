require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))
require File.expand_path(File.join(File.dirname(__FILE__), '../app'))
require File.expand_path(File.join(File.dirname(__FILE__), 'scam_association'))

describe FunkyPage, "class (< Page | has_scam :funk | has_scam :simple, :class_name => 'Scam')" do
  it 'should have scam_names [:content, :sidebar, :funk, :simple]' do
    FunkyPage.scam_names.should == [:content, :sidebar, :funk, :simple]
  end
  
  it 'should have one MarukuScam as :funk' do
    FunkyPage.reflect_on_association(:funk).macro.should == :has_one
    FunkyPage.reflect_on_association(:funk).klass.should == MarukuScam
  end

  it 'should have one Scam as :simple' do
    FunkyPage.reflect_on_association(:simple).macro.should == :has_one
    FunkyPage.reflect_on_association(:simple).klass.should == Scam
  end
end


describe FunkyPage, ' :funk association' do
  before { @scammable, @scam_name = FunkyPage.new, :funk }

  it_should_behave_like 'Scam association'
end

describe FunkyPage, ' :simple association' do
  before { @scammable, @scam_name = FunkyPage.new, :simple }

  it_should_behave_like 'Scam association'
end