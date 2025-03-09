# frozen_string_literal: true

module Violations
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
end
