require_relative 'helper'
require_relative '../../../lib/tpnoted/note'


module Tpnoted
  module Test
    class NoteTest < Tpnoted::Test::TestCase
      
      def setup
        @notes = []
      end
      
      def teardown
        @notes.each { |n| n.delete }
      end
      
      def test_create
        @notes << note = Tpnoted::Note.new('password')
        
        refute_nil note.uuid
      end
      
      def test_save_load
        title = "Ode on a Grecian Urn"
        body  = "Heard melodies are sweet, but those unheard" + $/ +
                "Are sweeter; therefore, ye soft pipes, play on;" + $/
        
        @notes << note = Tpnoted::Note.new('password')
        
        note.title = title
        note.body  = body
        
        note2 = Tpnoted::Note.new('password', :uuid => note.uuid)
        
        assert_equal note.uuid, note2.uuid
        assert_equal title, note2.title
        assert_equal body, note2.body
        
        note3 = Tpnoted::Note.new('password2', :uuid => note.uuid) # invalid
        
        assert_equal note.uuid, note3.uuid
        assert_nil note3.title
        assert_nil note3.body
      end
      
      def test_save_load_fast
        title = "Ode to a Nightingale"
        body  = "The voice I hear this passing night was heard" + $/ +
                "In ancient days by emperor and clown:" + $/
        
        @notes << note = Tpnoted::Note.new('password',
          :title => title,
          :body  => body
        )
        
        note2 = Tpnoted::Note.new('password', :uuid => note.uuid)
        
        assert_equal note.uuid, note2.uuid
        assert_equal title, note2.title
        assert_equal body, note2.body
      end
      
      def test_delete
        @notes << note = Tpnoted::Note.new('password')
        
        assert File.exists?(note.storage_file)
        
        note.delete
        
        refute File.exists?(note.storage_file)
      end
      
    end
  end
end
