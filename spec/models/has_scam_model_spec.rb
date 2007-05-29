require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../app'

describe HasScamModel, "(an ActiveRecord with has_scam specified)" do
  
end

describe HasScamModel, ':scam association' do
  before do
    @assoc = HasScamModel.reflect_on_association(:scam)
  end
  
  it { @assoc.macro.should equal :has_one }

  it 'should be ' @assoc.klass.should be_kind_of(Scam) }
end