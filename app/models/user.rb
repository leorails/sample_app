# == Schema Information
# Schema version: 20110206190724
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean
#

require 'digest'
class User < ActiveRecord::Base
  attr_accessor :password
  
  attr_accessible( :name, :email, :password, :password_confirmation)

  has_many :microposts, :dependent => :destroy  #, :foreign_key => "user_id", but since "User".underscore is user, the :foreign_key can be omitted.


  has_many :relationships, :foreign_key => "follower_id",
                           :dependent => :destroy
  # code like "has_many :followeds, :through => :relationships" would assemble an array using the followed_id in the relationships table. But, as noted in Section 12.1.1, user.followeds is rather awkward; far more natural is to treat “following” as a plural of “followed”, and write instead user.following for the array of followed users. Naturally, Rails allows us to override the default, in this case using the :source parameter (Listing 12.11), which explicitly tells Rails that the source of the following array is the set of followed ids.
  has_many :following, :through => :relationships, :source => :followed

  # Listing 12.17
  has_many :reverse_relationships, :foreign_key => "followed_id",
                                   :class_name => "Relationship",
                                   :dependent => :destroy
  has_many :followers, :through => :reverse_relationships, :source => :follower


  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates(:name, :presence => true, :length => { :maximum => 50 })
  validates :email, :presence => true,
                    :format   => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }

  # ActiveRecord Callback right before saving the record
  before_save :encrypt_password

  # Return true if the user's password matches the submitted password.
  def has_password?(submitted_password)
    # Compare encrypted_password with the encrypted version of
    # submitted_password.
    encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  def feed
    # This is preliminary. See Chapter 12 for the full implementation.
    # Micropost.where("user_id = ?", id)

    # Listing 12.41 - Adding completed feed to the User model
    Micropost.from_users_followed_by(self)
  end

  def following?(followed)
    self.relationships.find_by_followed_id(followed)
  end

  def follow!(followed)
    self.relationships.create!(:followed_id => followed.id)
  end

  def unfollow!(followed)
    self.relationships.find_by_followed_id(followed).destroy
  end
  
  private
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(self.password)
    end

    def encrypt(string)
      secure_hash("#{self.salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{self.password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end
