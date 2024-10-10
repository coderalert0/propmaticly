# frozen_string_literal: true

class Inspection < ApplicationRecord
  belongs_to :building

  enum state: {
    failed: 0,
    passed: 1,
    in_progress: 2
  }
end
