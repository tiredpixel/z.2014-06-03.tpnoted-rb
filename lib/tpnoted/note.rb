require_relative 'storeable'


module Tpnoted
  class Note
    
    STORAGE_DIR = 'notes'.freeze
    
    include Storeable
    
    def initialize(password, opts = {})
      self.password = password
      
      opts[:uuid] ? uuid(opts[:uuid]) : uuid
      
      self.title    = opts[:title] if opts[:title]
      self.body     = opts[:body]  if opts[:body]
    end
    
    def title
      storage['title']
    end
    
    def title=(v)
      storage['title'] = v
      
      save
    end
    
    def body
      storage['body']
    end
    
    def body=(v)
      storage['body'] = v
      
      save
    end
    
  end
end
