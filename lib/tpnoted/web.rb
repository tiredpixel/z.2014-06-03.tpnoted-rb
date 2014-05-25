abort "! .env environment missing" unless ENV['LOG_LEVEL']

require 'sinatra/base'
require 'sinatra/json'

$stdout.sync = true if ENV['LOG_SYNC'].to_i == 1

module Tpnoted
  class Web < Sinatra::Base
    
    set :logging, true
    
    helpers Sinatra::JSON
    
    before do
      logger.level = Logger.const_get(ENV['LOG_LEVEL'])
      logger.formatter = Logger::Formatter.new
    end
    
    get '/' do
      "Harro! :)"
    end
    
  end
end
