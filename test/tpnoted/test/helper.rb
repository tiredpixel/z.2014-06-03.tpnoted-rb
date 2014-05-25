abort "! .env environment missing" unless ENV['LOG_LEVEL']

ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'

require_relative '../../../lib/tpnoted/web'


module Tpnoted
  module Test
    class TestCase < MiniTest::Unit::TestCase
      
      include Rack::Test::Methods
      
      def app
        Tpnoted::Web
      end
      
    end
  end
end
