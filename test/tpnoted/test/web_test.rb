require 'json'

require_relative 'helper'


module Tpnoted
  module Test
    class WebTest < Tpnoted::Test::TestCase
      
      def test_home
        get '/'
        
        body = JSON.parse(last_response.body)
        
        assert last_response.ok?
        assert_equal "tpnoted", body['service']
        assert_kind_of Integer, body['version']
        assert Time.at(body['time'])
        refute_nil body['msg']
      end
      
    end
  end
end
