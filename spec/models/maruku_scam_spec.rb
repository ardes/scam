__DIR__ = File.dirname(__FILE__)
require File.expand_path("#{__DIR__}/../spec_helper")
require File.expand_path("#{__DIR__}/../app")
require File.expand_path("#{__DIR__}/scam_shared")

describe MarukuScam do
  before { @scam = MarukuScam.new }
  
  it_should_behave_like 'All Scams'
  
  it 'should have default_content_type of :html' do
    @scam.default_content_type.should == :html
  end
end

describe MarukuScam, ' saved, with no parsed_content' do
  before do
    @scam = MarukuScam.create(:name => :scam, :content => '# Heading')
  end
  
  it 'should return parsed html with #to_html' do
    @scam.to_html.should == "<h1 id='heading'>Heading</h1>"
  end
  
  it 'should return parsed html with #to_s' do
    @scam.to_s.should == "<h1 id='heading'>Heading</h1>"
  end
  
  it 'should return parsed string with #to_string' do
    @scam.to_string.should == 'Heading'
  end
end

describe MarukuScam, ' saved, with parsed_content' do
  before do
    @scam = MarukuScam.create(:name => :scam, :content => '# Heading')
    @scam.to_html
  end
  
  it 'should not save record with #to_html' do
    @scam.should_not_receive(:save)
    @scam.to_html
  end
end
  