require 'spec_helper'

describe CramMd5 do
  
  describe ".salt" do
    
    shared_examples_for "valid salt" do
      subject { CramMd5::salt(encrypted_password) }
      
      it { subject.should be_instance_of String }

      it { subject.length.should be_eql 8 }

      it "should be a valid salt" do
        encrypted_password.should include subject
      end
    end
    
    describe "given an unix md5 encrypted password" do
      it_should_behave_like "valid salt" do
        let(:encrypted_password) { CramMd5::unix_md5_crypt(CramMd5::rand_str) }
      end
    end
    
    describe "given an apache md5 encrypted password" do
      it_should_behave_like "valid salt" do
        let(:encrypted_password) { CramMd5::apache_md5_crypt(CramMd5::rand_str, CramMd5::rand_str) }
      end
    end
    
    context "given invalid passwords" do
      it { CramMd5::salt("223iNXZj2Lg$yfctCfdMMM32113ccasle").should be_nil }
      it { CramMd5::salt(123123).should be_nil }
      it { CramMd5::salt(nil).should be_nil }
      it { CramMd5::salt("1$23$%@@#%$").should be_nil }
    end
    
  end
  
end