# frozen_string_literal: true

class ComplaintListener
  def complaint_creation_successful(complaint_id)
    Complaint.find(complaint_id)
  end
end
