# frozen_string_literal: true

class HpdViolation < Violation
  enum state: {
    Open: 0,
    Close: 1
  }
end
