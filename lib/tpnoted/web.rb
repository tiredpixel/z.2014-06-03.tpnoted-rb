abort "! .env environment missing" unless ENV['LOG_LEVEL']

$stdout.sync = true if ENV['LOG_SYNC'].to_i == 1

require 'sinatra/base'
require 'sinatra/json'

require_relative 'note'


module Tpnoted
  class Web < Sinatra::Base
    
    API_VERSION = 1
    
    set :logging, true
    
    helpers Sinatra::JSON
    
    before do
      logger.level = Logger.const_get(ENV['LOG_LEVEL'])
      logger.formatter = Logger::Formatter.new
    end
    
    get '/' do
      json({
        :service => 'tpnoted',
        :version => API_VERSION,
        :time    => Time.now.to_i,
        :msg     => "Hello. Welcome to the tpnoted service."
      })
    end
    
    post '/notes' do
      note = Tpnoted::Note.new(params['password'],
        :title => params['title'],
        :body  => params['body']
      )
      
      status 201
      
      headers 'Location' => "/notes/#{note.uuid}"
    end
    
    get '/notes/:id' do
      note = Tpnoted::Note.new(params['password'], :uuid => params['id'])
      
      unless note.empty?
        status 200
        
        json({
          :id    => note.uuid,
          :title => note.title,
          :body  => note.body,
        })
      else
        status 404
      end
    end
    
  end
end
