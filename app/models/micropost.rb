class Micropost < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user

  default_scope :order => 'microposts.created_at DESC'

  # Listing 12.43 -
  # Return microposts from the users being followed by the given user.
  # The main reason scopes are better than plain class methods is that they can be chained with other methods, so that, for example,
  # scope :admin, where(:admin => true)
  # User.admin.paginate(:page => 1)
  # actually paginates the admins in the database; if (for some odd reason) the site has 100 administrators, the code above will still only pull out the first 30.
  scope :from_users_followed_by, lambda { |user| followed_by(user) }

  validates :content, :presence => true, :length => { :maximum => 140 }
  validates :user_id, :presence => true

#  def self.from_users_followed_by(user)
#    # Listing 12.42 - see how the "&" operator works
#    followed_ids = user.following.map(&:id).join(", ")
#    where("user_id IN (#{followed_ids}) OR user_id = ?", user)
#    # 2 problems with above code:
#      # 1. user.following.map statement pulls all the followed users into memory, and creates an array the full length of the following list.
#      # 2. these 2 statements  always pulls out all the microposts and sticks them into a Ruby array. Although these microposts are paginated in the view (Listing 11.33), the array is still full-sized
#
#  end

  private

    # Listing 12.44
    # Return an SQL condition for users followed by the given user.
    # We include the user's own id as well.
    def self.followed_by(user)
      # followed_ids = user.following.map(&:id).join(", ")

      followed_ids = %(SELECT followed_id FROM relationships
                       WHERE follower_id = :user_id)
      
      where("user_id IN (#{followed_ids}) OR user_id = :user_id",
            { :user_id => user })
    end
  
end
