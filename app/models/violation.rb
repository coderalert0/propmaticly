# frozen_string_literal: true

class Violation < ApplicationRecord
  belongs_to :building

  enum state: {
    closed: 0,
    open: 1
  }

  def state_options
    states = Violation.states.dup
    states.delete(state)
    states
  end
end
