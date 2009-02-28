ENV["RAILS_ENV"] = "test"
__DIR__ = File.dirname(__FILE__)

require 'rubygems'

begin
  # load rails env if it exists
  require "#{__DIR__}/../../../../config/environment"
  
rescue LoadError
  # otherwise build an env using gems, and loading libs
  require 'activesupport'
  require 'activerecord'
  $LOAD_PATH << "#{__DIR__}/../lib"
  require "#{__DIR__}/../init"
end

require 'spec'
require 'maruku'

# use local db and log
ActiveRecord::Base.logger = Logger.new("#{__DIR__}/log/test.log")
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :dbfile => "#{__DIR__}/db/test.sqlite3")