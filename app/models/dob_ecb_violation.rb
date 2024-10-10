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

  enum state: {
    ACTIVE: 0,
    RESOLVE: 1
  }
end
