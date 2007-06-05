require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))
require File.expand_path(File.join(File.dirname(__FILE__), '../app'))
require File.expand_path(File.join(File.dirname(__FILE__), '../shared/scammable'))

describe Product, "class (has_scam)" do
  it 'should have scam_names [:scam]' do
    Product.scam_names.should == [:scam]
  end
end

describe_scam_associations Product, :scam

describe Product, ".new" do
  before do
    @product = Product.new
  end
end