require 'fileutils'
require 'securerandom'
require 'json'


module Tpnoted
  module Storeable
    
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def storage_dir
        unless @storage_dir
          @storage_dir = File.join(ENV['STORAGE_DIR'], self::STORAGE_DIR).freeze
          
          FileUtils.mkdir(@storage_dir) unless File.exists?(@storage_dir)
        end
        
        @storage_dir
      end
    end
    
    def storage
      @storage ||= {}
    end
    
    def uuid(uuid = nil)
      unless @uuid
        if uuid
          @uuid = uuid
          
          load
        else
          until @uuid do
            uuid_cand = SecureRandom.uuid
            
            f = File.join(self.class.storage_dir, uuid_cand)
            
            unless File.exists?(f) # collision?
              FileUtils.touch(f)
              
              @uuid = uuid_cand
              
              save
            end
          end
        end
      end
      
      @uuid
    end
    
    def storage_file
      File.join(self.class.storage_dir, uuid)
    end
    
    def load
      @storage = JSON.parse(File.read(storage_file))
    end
    
    def save
      File.write(storage_file, storage.to_json)
    end
    
    def delete
      FileUtils.rm(storage_file) if File.exists?(storage_file)
    end
    
  end
end
