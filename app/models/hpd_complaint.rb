# frozen_string_literal: true

class HpdComplaint < Complaint
  def self.mapped_state(state)
    case state
    when 'OPEN'
      0
    when 'CLOSE'
      2
    end
  end
end
