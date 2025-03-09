# frozen_string_literal: true

module Complaints
  class FetchDobComplaintsJob < ::FetchComplaintsViolationsJob
    private

    def url
      'https://data.cityofnewyork.us/resource/eabe-havv.json'
    end

    def resource_where_params(complaint, building)
      { complaint_id: complaint['complaint_number'], building: building }
    end

    def resource_update_attributes(complaint)
      { filed_date: (Date.strptime(complaint['date_entered'], '%m/%d/%Y') if complaint['date_entered']),
        description: (if complaint['complaint_category']
                        I18n.t("complaint_category.#{complaint['complaint_category']}")
                      end),
        disposition_date: (Date.strptime(complaint['disposition_date'], '%m/%d/%Y') if complaint['disposition_date']),
        disposition_code: complaint['disposition_code'],
        category_code: complaint['complaint_category'],
        inspection_date: (Date.strptime(complaint['inspection_date'], '%m/%d/%Y') if complaint['inspection_date']),
        state: resource_clazz.mapped_state(complaint['status']) }
    end

    def resource_clazz
      Complaints::DobComplaint
    end
  end
end
