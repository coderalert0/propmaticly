# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :notifiable, polymorphic: true
  belongs_to :user

  validates :user_id, uniqueness: { scope: %i[notifiable_type notifiable_id] }
end
