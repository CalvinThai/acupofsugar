class User < ApplicationRecord
  before_create :confirmation_token
  #searchkick gem
  searchkick
  User.reindex
  #has_friendship gem
  has_friendship

  has_many :items, dependent: :destroy
  has_many :wish_lists, dependent: :destroy
  has_many :borrowed_items, dependent: :destroy
  has_many :on_hold_items, dependent: :destroy
  has_many :review_lender_and_items, dependent: :destroy
  has_many :review_borrowers, dependent: :destroy
  has_many :conversations, :foreign_key => :sender_id
  has_one_attached :avatar


  def self.user_search(name)
    if name.present?
        name = name.gsub(/[^0-9A-Za-z\s]/, '')
        @users = User.search name, operator: "or", fields: [:lname,:fname], misspellings: {edit_distance: 3}, limit: 5
    else
      return nil
    end
  end
  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
    save!(:validate => false)
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver_now
  end

  def generate_token(column)
    begin
      self[column]= SecureRandom.urlsafe_base64
    end while User.exists?(column=> self[column])
  end


  before_save { self.email = email.downcase }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
 # validates :password, presence: false, length: { minimum: 6 }

  private
  def confirmation_token
    if self.confirm_token.blank?
      self.confirm_token = SecureRandom.urlsafe_base64.to_s
    end
  end

end
