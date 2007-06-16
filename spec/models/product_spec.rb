require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))
require File.expand_path(File.join(File.dirname(__FILE__), '../app'))
require File.expand_path(File.join(File.dirname(__FILE__), 'scam_association'))
require File.expand_path(File.join(File.dirname(__FILE__), 'scammable'))

describe Product, "class (has_scam)" do
  it 'should have scam names: :scam' do
    Product.scam_names.should == [:scam]
  end
  
  it 'should have one Scam as :scam' do
    Product.reflect_on_association(:scam).macro.should == :has_one
    Product.reflect_on_association(:scam).klass.should == Scam
  end
end

describe Product, " :scam association" do
  before { @scammable, @scam_name = Product.new, :scam }
  
  it_should_behave_like 'Scam association'
end

describe Product, ".new" do
  before { @scammable = Product.new }
  
  it_should_behave_like 'Scammable with scams not loaded'
end

