require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))
require File.expand_path(File.join(File.dirname(__FILE__), '../app'))
require File.expand_path(File.join(File.dirname(__FILE__), '../shared/scammable'))

describe FunkyPage, "class (< Page | has_scam :funk | has_scam :normal, :class_name => 'Scam')" do
  it 'should have scam_names [:content, :sidebar, :funk, :normal]' do
    FunkyPage.scam_names.should == [:content, :sidebar, :funk]
  end
end

describe_scam_associations FunkyPage, :content, :sidebar, :funk
