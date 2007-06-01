require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))
require File.expand_path(File.join(File.dirname(__FILE__), '../app'))
require File.expand_path(File.join(File.dirname(__FILE__), '../lib/scammable'))

describe FunkyPage, "class (< Page | has_scam :funk | has_scam :normal, :class_name => 'Scam')" do
  it 'should have scam_names [:content, :sidebar, :funk, :normal]' do
    FunkyPage.scam_names.should == [:content, :sidebar, :funk, :normal]
  end
end

describe_scam_associations FunkyPage, {:content => PageScam, :sidebar => PageScam, :funk => PageScam, :normal => Scam}
