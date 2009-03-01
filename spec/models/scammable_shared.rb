# set @scammable before using these shared examples
describe 'Scammable with scams not loaded', :shared => true do
  it 'should not attempt to save scams on save' do
    @scammable.scam_names.each do |scam_name|
      @scammable.should_not_receive(scam_name)
    end
    @scammable.save
  end
end