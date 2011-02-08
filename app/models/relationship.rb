class Relationship < ActiveRecord::Base
  # In the case of the Relationship model, the followed_id should be accessible, since users will create relationships through the web, but the follower_id attribute should not be accessible; otherwise, malicious users could force other users to follow them.
  attr_accessible :followed_id

  # Rails infers the names of the foreign keys from the corresponding symbols (i.e., follower_id from :follower, and followed_id from :followed), but since there is neither a Followed nor a Follower model we need to supply the class name User. 
  belongs_to :follower, :class_name => "User"
  belongs_to :followed, :class_name => "User"

  validates :follower_id, :presence => true
  validates :followed_id, :presence => true
end
