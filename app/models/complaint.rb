# frozen_string_literal: true

class Complaint < ApplicationRecord
  belongs_to :building
  after_commit :send_notification, on: :create

  enum state: {
    open: 0,
    in_progress: 1,
    closed: 2
  }

  scope :open, -> { where(state: 0) }
  scope :in_progress, -> { where(state: 1) }
  scope :closed, -> { where(state: 2) }

  def state_options
    states = Complaint.states.dup
    states.delete(state)
    states
  end

  private

  def send_notification
    ComplaintNotifierJob.perform_later id
  end
end
