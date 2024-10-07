# frozen_string_literal: true

class Organization < ApplicationRecord
  has_many :users
  has_many :portfolios
  has_many :buildings, through: :portfolios
  has_many :complaints, through: :buildings
  has_many :violations, through: :buildings
end
