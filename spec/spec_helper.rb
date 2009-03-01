ENV["RAILS_ENV"] = "test"
__DIR__ = File.dirname(__FILE__)

require 'rubygems'

# use rails env if it exists, otherwise make one from gems
begin
  require "#{__DIR__}/../../../../config/environment"
rescue LoadError
  require 'activerecord'
  $LOAD_PATH << "#{__DIR__}/../lib"
  require "#{__DIR__}/../init"
  ActiveRecord::Base.logger = Logger.new("#{__DIR__}/log/test.log")
  ActiveRecord::Base.establish_connection(YAML.load(File.read("#{__DIR__}/db/database.yml"))['test'])
end

require 'spec'
require 'maruku'
