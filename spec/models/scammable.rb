require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))
require File.expand_path(File.join(File.dirname(__FILE__), '../app'))

# set @scammable before using these shared examples
describe 'Scammable with scams not loaded', :shared => true do
  it 'should not attempt to save scams on save' do
    @scammable.scam_names.each {|scam_name| @scam_name.should_not_receive(scam_name) }
    @scammable.save
  end
end