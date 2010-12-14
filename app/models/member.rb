require "digest/sha2"
class Member < ActiveRecord::Base
  has_many :platforms
  has_many :campaigns

  validates_uniqueness_of :login

  before_save :update_hashed_password
  after_save :clean_password
  
  attr_accessor :password
  
  attr_protected :hashed_password, :salt
  
  def self.hash_with_salt password, salt
    Digest::SHA2.hexdigest "Take #{password} and #{salt} and make hash, mortal"
  end

  def self.make_salt member
    Digest::SHA2.hexdigest "Take #{Time.now.to_i} and #{member.login} and make salt!";
  end

  def self.authenticate login = "", password = ""
    member = Member.find_by_login(login)
    if member && member.hashed_password == Member.hash_with_salt(password, member.salt)
      member
    else
      false
    end
  end

  private

  def update_hashed_password
    if password
      self.salt = Member.make_salt self if salt.blank?
      self.hashed_password = Member.hash_with_salt password, salt
    end
  end

  def clean_password
    self.password = nil
  end

end
