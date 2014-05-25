require_relative 'helper'


module Tpnoted
  module Test
    class WebTest < Tpnoted::Test::TestCase
      
      def test_home
        get '/'
        assert last_response.ok?
        assert_equal "Harro! :)", last_response.body
      end
      
    end
  end
end
