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

  def self.mapped_severity(severity)
    case severity
    when 'NON EMERGENCY'
      0
    when 'EMERGENCY'
      1
    when 'IMMEDIATE EMERGENCY'
      2
    end
  end
end
