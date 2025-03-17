# frozen_string_literal: true

class Portfolio < ApplicationRecord
  belongs_to :organization
  has_many :buildings, dependent: :destroy
  has_many :complaints, through: :buildings, dependent: :destroy
  has_many :violations, through: :buildings, dependent: :destroy
  has_many :inspections, through: :buildings, dependent: :destroy
  has_many :asset_contacts, as: :assignable, dependent: :destroy
  has_many :users, through: :asset_contacts

  validates :name, :organization_id, presence: true
end
