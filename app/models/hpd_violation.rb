# frozen_string_literal: true

class HpdViolation < Violation
  def self.mapped_state(state)
    case state
    when 'Open'
      0
    when 'Close'
      2
    end
  end
end
