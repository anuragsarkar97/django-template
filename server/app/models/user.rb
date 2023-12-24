# frozen_string_literal: true

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic
  include ActiveModel::SecurePassword

  field :name, type: String
  field :email, type: String
  field :password_digest
  has_secure_password
  field :verified, type: Boolean, default: false
  field :verification_token, type: String
  field :verification_token_sent_at, type: DateTime
  field :created_with_ip, type: String

  belongs_to :team

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  def token
    token = SecureRandom.hex(12)
    Rails.cache.fetch("user_token_#{token}", expires_in: 7.days) do
      self.id
    end
    token
  end

  def self.user_from_token(token)
    id = Rails.cache.fetch("user_token_#{token}", expires_in: 7.days) do
      self.id
    end
    User.find(id)
  end

end
