# frozen_string_literal: true

class User < ApplicationRecord
  belongs_to :organization
  accepts_nested_attributes_for :organization

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
end
