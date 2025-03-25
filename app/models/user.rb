# frozen_string_literal: true

class User < ApplicationRecord
  belongs_to :organization
  has_many :asset_contacts, dependent: :destroy
  has_many :buildings, through: :asset_contacts, source: :assignable, source_type: 'Building'
  has_many :portfolios, through: :asset_contacts, source: :assignable, source_type: 'Portfolio'

  validates :first_name, :last_name, :email, :encrypted_password, presence: true
  validates :email, uniqueness: true

  phony_normalize :sms, default_country_code: 'US'
  validates_plausible_phone :sms, default_country_code: 'US', country_number: '1'

  # Accepts nested attributes for organizations and assignable models
  accepts_nested_attributes_for :buildings, :portfolios, :organization

  # Include default devise modules
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :timeoutable
end
