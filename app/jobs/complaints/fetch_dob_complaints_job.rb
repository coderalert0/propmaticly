# frozen_string_literal: true

module Complaints
  class FetchDobComplaintsJob < ::FetchComplaintsViolationsJob
    private

    def url
      'https://data.cityofnewyork.us/resource/eabe-havv.json'
    end

    def resource_where_params
      { complaint_id: @resource['complaint_number'], building: @building }
    end

    def resource_update_attributes
      {
        filed_date: (Date.strptime(@resource['date_entered'], '%m/%d/%Y') if @resource['date_entered']),
        description: (if @resource['complaint_category']
                        I18n.t("complaint_category.#{@resource['complaint_category']}")
                      end),
        disposition_date: (Date.strptime(@resource['disposition_date'], '%m/%d/%Y') if @resource['disposition_date']),
        disposition_code: @resource['disposition_code'],
        category_code: @resource['complaint_category'],
        inspection_date: (Date.strptime(@resource['inspection_date'], '%m/%d/%Y') if @resource['inspection_date'])
      }
    end

    def resource_clazz
      Complaints::DobComplaint
    end

    def state
      resource_clazz.mapped_state(@resource['status'])
    end
  end
end
