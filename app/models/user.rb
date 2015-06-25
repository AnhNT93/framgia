class User < ActiveRecord::Base
  has_many :entries, dependent: :destroy
  has_many :comments
  has_many :active_relationships,  class_name:  "Relationship",
                                   foreign_key: "follower_id",
                                   dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  before_save :downcase_email
  validates :name, length: {minium: 6, maximum: 50},
  				   presence: true,
  				   uniqueness: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates	:email, length: {maximum: 255},
  				    presence: true,
  				    format: {with: VALID_EMAIL_REGEX},
  				    uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, length: {minimum: 6},
  					   presence: true

  def downcase_email
    self.email = email.downcase
  end
  def authenticated?(remember_token)
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Unfollows a user.
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end
end
