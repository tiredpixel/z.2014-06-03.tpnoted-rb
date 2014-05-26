require 'fileutils'
require 'securerandom'
require 'json'
require 'openssl'


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
      
      def password_cipher
        OpenSSL::Cipher::AES.new(128, :CBC)
      end
    end
    
    def storage
      @storage ||= {}
    end
    
    def uuid(uuid = nil)
      unless @uuid
        if uuid
          @uuid = uuid
          
          @password_iv = File.binread(storage_file_iv) if File.exists?(storage_file_iv)
          
          load
        else
          until @uuid do
            uuid_cand = SecureRandom.uuid
            
            f = File.join(self.class.storage_dir, uuid_cand)
            
            unless File.exists?(f) # collision?
              FileUtils.touch(f)
              
              @password_iv = self.class.password_cipher.random_iv
              
              @uuid = uuid_cand
              
              File.binwrite(storage_file_iv, @password_iv)
              
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
    
    def storage_file_iv
      File.join(self.class.storage_dir, uuid + '.iv')
    end
    
    def password=(v)
      @password_key = OpenSSL::PKCS5.pbkdf2_hmac_sha1(
        v,
        ENV['ENCRYPTION_SALT'],
        ENV['ENCRYPTION_ITER'].to_i,
        ENV['ENCRYPTION_LEN'].to_i
      )
    end
    
    def load
      ciphertext = File.read(storage_file)
      
      data_dec = encrypt_decrypt(:decrypt, ciphertext)
      
      return unless data_dec # invalid
      
      @storage = JSON.parse(data_dec)
    end
    
    def save
      plaintext = storage.to_json
      
      data_enc = encrypt_decrypt(:encrypt, plaintext)
      
      return unless data_enc # invalid
      
      File.write(storage_file, data_enc)
    end
    
    def delete
      FileUtils.rm(storage_file)    if File.exists?(storage_file)
      FileUtils.rm(storage_file_iv) if File.exists?(storage_file_iv)
    end
    
    def encrypt_decrypt(mode, data)
      cipher = self.class.password_cipher
      
      cipher.send(mode)
      cipher.key = @password_key
      cipher.iv  = @password_iv
      
      begin
        cipher.update(data) + cipher.final
      rescue OpenSSL::Cipher::CipherError
      end
    end
    
  end
end
