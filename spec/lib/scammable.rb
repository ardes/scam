describe Scammer::Scammable, ' scam association', :shared => true do
  it 'should be :has_one' do
    @assoc.macro.should == :has_one
  end
end