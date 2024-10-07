# frozen_string_literal: true

class Building < ApplicationRecord
  belongs_to :portfolio
  has_many :buildings_users
  has_many :complaints, dependent: :destroy
  has_many :violations, dependent: :destroy

  validates_presence_of :name, :address1, :zip5
end
