# frozen_string_literal: true

class Organization < ApplicationRecord
  has_many :users
  has_many :portfolios
  has_many :buildings, through: :portfolios
  has_many :complaints, class_name: 'Complaints::Complaint', through: :buildings
  has_many :violations, class_name: 'Violations::Violation', through: :buildings
  has_many :inspections, through: :buildings

  validates :name, presence: true
end
