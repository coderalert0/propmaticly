# frozen_string_literal: true

class Portfolio < ApplicationRecord
  belongs_to :organization
  has_many :buildings, dependent: :destroy
  has_many :complaints, through: :buildings, dependent: :destroy

  validates_presence_of :name
end
