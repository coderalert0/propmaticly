# frozen_string_literal: true

class Violation < ApplicationRecord
  belongs_to :building

  enum state: {
    open: 0,
    in_progress: 1,
    closed: 2
  }
end
