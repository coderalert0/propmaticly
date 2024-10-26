# frozen_string_literal: true

class Portfolio < ApplicationRecord
  belongs_to :organization
  has_many :buildings, dependent: :destroy
  has_many :complaints, through: :buildings, dependent: :destroy
  has_many :asset_contacts, as: :assignable, dependent: :destroy
  has_many :users, through: :asset_contacts

  validates :name, presence: true

  attr_writer :user_ids

  def update_asset_contacts(user_ids)
    ActiveRecord::Base.transaction do
      asset_contacts.where(assignable_type: 'Portfolio').destroy_all

      user_ids&.reject(&:blank?)&.each do |user_id|
        asset_contacts.create!(user_id: user_id, assignable: self)
      end
    end
  end

  def user_ids
    users.pluck(:id)
  end
end
