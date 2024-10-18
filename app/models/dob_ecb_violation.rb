# frozen_string_literal: true

class DobEcbViolation < Violation
  enum severity: {
    Hazardous: 0,
    "Non-Hazardous": 1,
    "CLASS - 1": 2,
    "CLASS - 2": 3,
    "CLASS - 3": 4,
    Unknown: 5
  }

  def self.mapped_state(state)
    case state
    when 'ACTIVE'
      0
    when 'RESOLVE'
      2
    end
  end
end
