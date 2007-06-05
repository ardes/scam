require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))
require File.expand_path(File.join(File.dirname(__FILE__), '../app'))

describe Product, "class (has_scam)" do
  it 'should have scam_names [:scam]' do
    Product.scam_names.should == [:scam]
  end
  
  it 'should have one :scam Scam association' do
    Product.reflect_on_association(:scam).macro.should == :has_one
    Product.reflect_on_association(:scam).klass.should == Scam
  end
end

describe Product, ".new" do
  before do
    @product = Product.new
  end
end