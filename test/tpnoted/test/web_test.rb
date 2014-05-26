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
      
      def test_notes_post_get
        data = {
          'password' => "password123",
          'title'    => "TO AUTUMN.",
          'body'     => "Sometimes whoever seeks abroad may find" + $/ +
                        "Thee sitting careless on a granary floor, " + $/
        }
        
        post '/notes', data
        
        re_notes_id = /^\/notes\/([\w-]+)$/
        
        assert_equal 201, last_response.status
        assert_match re_notes_id, last_response.location
        
        location = last_response.location
        
        get location, 'password' => data['password']
        
        body = JSON.parse(last_response.body)
        
        assert_equal 200, last_response.status
        assert_equal re_notes_id.match(location)[1], body['id']
        assert_equal data['title'], body['title']
        assert_equal data['body'], body['body']
      end
      
      def test_notes_get_not_found
        get '/notes/X', 'password' => 'passwordX'
        
        assert_equal 404, last_response.status
      end
      
    end
  end
end
