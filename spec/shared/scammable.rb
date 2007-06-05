describe Scammable, ' scam association', :shared => true do
  it 'should be :has_one' do
    @assoc.macro.should == :has_one
  end
end

# usage: describe_scam_associations klass, :scam_name [, :next_scam_name [,...]]
def describe_scam_associations(scammable_class, *assocs)
  assocs.each do |assoc|
    
    describe scammable_class, " :#{assoc} association" do
      before do
        @assoc = scammable_class.reflect_on_association(assoc)
      end
  
      it_should_behave_like 'Scammable scam association'
    end
    
  end
end