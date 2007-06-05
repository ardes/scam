describe Scammer::Scammable, ' scam association', :shared => true do
  it 'should be :has_one' do
    @assoc.macro.should == :has_one
  end
end

def describe_scam_associations(scammable_class, assocs)
  assocs.each do |assoc, scam_class|
    
    describe scammable_class, " :#{assoc} association" do
      before do
        @assoc = scammable_class.reflect_on_association(assoc)
      end
  
      it_should_behave_like 'Scammer::Scammable scam association'
  
      it "klass should be #{scam_class.name}" do
        @assoc.klass.should == scam_class
      end
    end
  
  end
end