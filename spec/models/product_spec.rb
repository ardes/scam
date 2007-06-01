require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))
require File.expand_path(File.join(File.dirname(__FILE__), '../app'))
require File.expand_path(File.join(File.dirname(__FILE__), '../lib/scammable'))

describe Product, "(an ActiveRecord with has_scam)" do

end

describe Product, " :scam association" do
  before do
    @assoc = Product.reflect_on_association(:scam)
  end

  it_should_behave_like 'Scammer::Scammable scam association'
  
  it 'should have klass of Scam' do
    @assoc.klass.should == Scam
  end
end

describe Product, ".new" do
  before do
    @product = Product.new
  end
end