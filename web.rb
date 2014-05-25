require 'sinatra/base'

$stdout.sync = true if ENV['LOG_SYNC'].to_i == 1

module Tpnoted
  class Web < Sinatra::Base
    
    set :logging, true
    
    get '/' do
      "Harro! :)"
    end
    
  end
end
