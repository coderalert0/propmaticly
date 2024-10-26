# frozen_string_literal: true

class HpdComplaint < Complaint
  STATE_MAPPING = {
    'OPEN' => 0,
    'CLOSE' => 2
  }.freeze

  SEVERITY_MAPPING = {
    'NON EMERGENCY' => 0,
    'EMERGENCY' => 1,
    'IMMEDIATE EMERGENCY' => 2
  }.freeze

  def self.mapped_state(state)
    STATE_MAPPING[state]
  end

  def self.mapped_severity(severity)
    SEVERITY_MAPPING[severity]
  end
end
