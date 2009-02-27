ENV["RAILS_ENV"] ||= "test"
__DIR__ = File.dirname(__FILE__)

require 'rubygems'

# if we're in a rails env, use that, otherwise use rubygems to create a spec env
begin
  require "#{__DIR__}/../../../../config/environment"
rescue LoadError
  require 'activesupport'
  require 'activerecord'
  $LOAD_PATH << "#{__DIR__}/../lib"
  require "#{__DIR__}/../init"
end

require 'spec'
require 'maruku'