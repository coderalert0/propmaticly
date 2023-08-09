# frozen_string_literal: true

class Organization < ApplicationRecord
  has_many :users
  has_many :portfolios
  has_many :buildings, through: :portfolios
end
