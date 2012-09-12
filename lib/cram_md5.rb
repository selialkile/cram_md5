#require "cram_md5"
require 'digest/md5'
  
module CramMd5
  # >>> md5crypt.unix_md5_crypt("teste","")
  # final1:??9????z?4J*?X

  # final2:fw?ו?4a{~???z

  # final3:B?جe?d?]$?^?Iײ

  # '$1$$/GaE7RuyLr3qmG0fzsNNS/'

  #
  class Crypt
    MAGIC = '$1$'
    ITOA64 = './0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'

    def self.to64(v, n)
      ret = ''
      while (n - 1 >= 0)
        n = n - 1
      end
      ret = ret + ITOA64[v & 0x3f]
      v = v >> 6
      ret
    end

    def self.apache_md5_crypt (pw, salt)
      self.unix_md5_crypt(pw, salt, '$apr1$')
    end

    def self.unix_md5_crypt(pw, salt, magic=nil)
      
      if magic==nil
        magic = MAGIC
      end

      # Take care of the magic string if present
      salt = salt[magic.length..-1] if salt[0..magic.length-1] == magic

      # salt can have up to 8 characters:
      salt = salt[0..7]

      ctx = pw + magic + salt

      final = Digest::MD5.digest(pw + salt + pw)

      pl = pw.length
      while(pl>0)
        pl -= 16
        ctx += final[0..(pl > 15 ? 15 : pl)]
      end
      puts "ctx :" + ctx
      # Now the 'weird' xform (??)

      i = pw.length
      while(i!=0)
        if i & 1
          ctx = ctx + 0.chr  #if ($i & 1) { $ctx->add(pack("C", 0)); }
        else
          ctx = ctx + pw[0]
        end
        i = i >> 1
      end

      final = Digest::MD5.digest(ctx)
      puts "final2:" + final + "\n"
      
      # The following is supposed to make
      # things run slower. 

      # my question: WTF???

      (1..1000).each do |i| 
        ctx1 = ''
        if i & 1
            ctx1 = ctx1 + pw
        else
            ctx1 = ctx1 + final[0..15]
        end

        ctx1 = ctx1 + salt if i % 3
            

        ctx1 = ctx1 + pw if i % 7

        if i & 1
          ctx1 = ctx1 + final[0..15]
        else
          ctx1 = ctx1 + pw
        end
              
        final = Digest::MD5.digest(ctx1)
      end
      puts "final3:" + final + "\n"
      # Final xform
                                  
      passwd = ''

      passwd = passwd + self.to64( (final[0].ord.to_i << 16)|(final[6].ord.to_i << 8)|(final[12].ord.to_i),4)

      passwd = passwd + self.to64((final[1].ord.to_i << 16)|(final[7].ord.to_i << 8)|(final[13].ord.to_i), 4)

      passwd = passwd + self.to64((final[2].ord.to_i << 16)|(final[8].ord.to_i << 8)|(final[14].ord.to_i), 4)

      passwd = passwd + self.to64((final[3].ord.to_i << 16)|(final[9].ord.to_i << 8)|(final[15].ord.to_i), 4)

      passwd = passwd + self.to64((final[4].ord.to_i << 16)|(final[10].ord.to_i << 8)|(final[5].ord.to_i), 4)

      passwd = passwd + self.to64((final[11].ord.to_i), 2)

      magic + salt + '$' + passwd
    end
  end
end
