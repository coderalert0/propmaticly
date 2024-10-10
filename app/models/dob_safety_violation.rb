# frozen_string_literal: true

class DobSafetyViolation < Violation
  enum state: {
    Active: 0,
    Dismissed: 1
  }
end
