# frozen_string_literal: true

module Violations
  class DobSafetyViolation < Violation
    def self.mapped_state(state)
      case state
      when 'Active'
        0
      when 'Dismissed'
        2
      end
    end
  end
end
