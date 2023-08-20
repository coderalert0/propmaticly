# frozen_string_literal: true

class Complaint < ApplicationRecord
  include Wisper::Publisher

  belongs_to :building
  after_commit :publish_creation_successful, on: :create

  enum state: {
    open: 0,
    in_progress: 1,
    closed: 2
  }

  private

  def publish_creation_successful
    broadcast(:complaint_creation_successful, self)
  end
end
