# frozen_string_literal: true

class DobEcbViolation < Violation
  def self.mapped_severity(severity)
    case severity
    when 'CLASS - 3, Non-Hazardous'
      0
    when 'CLASS - 2', 'Hazardous'
      1
    when 'CLASS - 1'
      2
    end
  end

  def self.mapped_state(state)
    case state
    when 'ACTIVE'
      0
    when 'RESOLVE'
      2
    end
  end
end
