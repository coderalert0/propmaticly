# frozen_string_literal: true

module Complaints
  class DobComplaint < Complaint
    def self.mapped_state(state)
      case state
      when 'ACTIVE'
        0
      when 'CLOSED'
        2
      end
    end
  end
end
