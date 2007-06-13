require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))
require File.expand_path(File.join(File.dirname(__FILE__), '../app'))

# set @scammable (instance of scammable) and @scam_name (symbol) before using these shared examples
describe "Scam association", :shared => true do
  before { @assoc = @scammable.send(@scam_name) }

  it 'should be built on demand' do
    @assoc.should be_kind_of(Scam)
  end
  
  it '#scam_name=(of scam type) should replace scam' do
    @scammable.send("#{@scam_name}=", other = @assoc.class.create)
    @scammable.instance_variable_get("@#{@scam_name}").should == other
  end
  
  it "#scam_name=(non Scam) should delegate to current scam's :content" do
    @assoc.should_receive(:content=).with('Gday').once
    @scammable.send("#{@scam_name}=", 'Gday')
  end
  
  it "should have name == :scam_name" do
    @assoc.name.should == @scam_name
  end
  
  it 'should be saved when parent scammable saved' do
    @assoc.should_receive(:save).once
    @scammable.save
  end
end