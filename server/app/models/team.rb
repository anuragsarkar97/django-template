# frozen_string_literal: true

class Team

  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic
  include ActiveModel::SecurePassword

  field :slug, type: String

  has_many :users
  has_many :sub_teams, class_name: 'Team', inverse_of: :parent_team

  validates :slug, presence: true, uniqueness: true

end
