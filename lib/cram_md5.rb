# -*- encoding: utf-8 -*-
require 'digest/md5'
  
module CramMd5
  MAGIC = '$1$'
  ITOA64 = './0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'

  def self.to64(v, n)
    ret = ''
    while (n - 1 >= 0)
      n = n - 1
    
      ret = ret + ITOA64[v & 0x3f]
      v = v >> 6
    end
    ret
  end
  
  # Returns Salt from a password
  # 
  # @param [String] password An unix md5 crypted password
  # @return [String] salt The Sal from the crypted password
  # @return [Nil] if the password is invalid
  def self.salt(password)
    if password =~ /\$.+\$.+\$/ and password.length > 30
      return $1 if password =~ /\$.+\$(.+)\$/
    end
    nil
  end

  def self.apache_md5_crypt(pw, salt)
    self.unix_md5_crypt(pw, salt, '$apr1$')
  end

  #@params [string] password
  #@params [string] salt
  #@params [string] magic
  #@note For compare, use de original password and the salt of encrypted password.
  #@return [string] crypt pass
  def self.unix_md5_crypt(pw, salt="", magic=nil)
    
    if magic==nil
      magic = MAGIC
    end

    # Take care of the magic string if present
    salt = salt[magic.length..-1] if salt[0..magic.length-1] == magic

    # salt can have up to 8 characters:
    salt = salt[0..7]
    salt = rand_str(8) if salt == ""

    ctx = pw + magic + salt

    final = Digest::MD5.digest(pw + salt + pw)

    pl = pw.length
    while(pl>0)
      if pl > 16
        ctx = ctx + final[0..15]
      else
        ctx = ctx + final[0..pl-1]
      end
      pl -= 16
    end
    # Now the 'weird' xform (??)

    i = pw.length
    while(i>0)
      if (i & 1) > 0
        ctx = ctx + 0.chr  #if ($i & 1) { $ctx->add(pack("C", 0)); }
      else
        ctx = ctx + pw[0]
      end
      i = i >> 1
    end

    final = Digest::MD5.digest(ctx)
    
    # The following is supposed to make
    # things run slower. 

    # my question: WTF???

    (0..999).each do |i| 
      ctx1 = ''
      if (i & 1) > 0
          ctx1 = ctx1 + pw
      else
          ctx1 = ctx1 + final[0..15]
      end

      ctx1 = ctx1 + salt if (i % 3) > 0
          

      ctx1 = ctx1 + pw if (i % 7) > 0

      if (i & 1) > 0
        ctx1 = ctx1 + final[0..15]
      else
        ctx1 = ctx1 + pw
      end
            
      final = Digest::MD5.digest(ctx1)
    end
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

  def self.rand_str(max_length = 32, chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890')

    chars_length = (chars.length - 1);

    string = chars[rand(chars_length)];
    i=0
    while(string.length<max_length)
      c = chars[rand(chars_length)];
     
      string += c if (c != string[string.length - 1])
    end
   
    string
 end

end
