__DIR__ = File.dirname(__FILE__)
require File.expand_path("#{__DIR__}/../spec_helper")
require File.expand_path("#{__DIR__}/../app")
require File.expand_path("#{__DIR__}/scam_association_shared")
require File.expand_path("#{__DIR__}/scammable_shared")

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
  before { @product = @scammable = Product.new }
  
  it_should_behave_like 'Scammable with scams not loaded'
end

describe Product, " with existing scam with cached parsed content" do
  before do
    p = Product.new
    p.scam = 'Gday'
    p.scam.parsed_content
    p.save
    @scam = Scam.find(p.scam.id)
    @product = Product.find(p.id)
  end
  
  it 'should be associated with correct scam' do
    @product.scam.should == @scam
  end
  
  it 'scam.to_s should not save the scam cache' do
    @scam.should_not_receive(:save)
    @product.scam.to_s.should == 'Gday'
  end
  
  it 'should destroy scams when destroyed' do
    @product.destroy
    lambda { Scam.find(@scam.id) }.should raise_error(ActiveRecord::RecordNotFound)
  end
end