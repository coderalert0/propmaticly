# frozen_string_literal: true

class User < ApplicationRecord
  belongs_to :organization
  has_many :building_users, dependent: :destroy
  has_many :buildings, through: :building_users
  accepts_nested_attributes_for :buildings, :organization

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
end
