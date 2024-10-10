# frozen_string_literal: true

class ComplaintDecorator < Draper::Decorator
  delegate_all

  def state
    clazz = case object.state
            when 'open'
              'badge-light-danger'
            when 'in_progress'
              'badge-light-primary'
            when 'closed'
              'badge-light-success'
            end
    h.content_tag(:span, class: "badge py-3 px-4 fs-7 #{clazz}") do
      I18n.t("complaint_state.#{object.state}")
    end
  end

  def severity
    clazz = case object.severity
            when 'emergency'
              'badge-light-danger'
            when 'non_emergency'
              'badge-light-success'
            end
    h.content_tag(:span, class: "badge py-3 px-4 fs-7 #{clazz}") do
      I18n.t("complaint_severity.#{object.severity}")
    end
  end

  def category_code
    I18n.t("complaint_category.#{object.category_code}") unless object.category_code.blank?
  end

  def disposition_code
    I18n.t("disposition_code.#{object.disposition_code}") unless object.disposition_code.blank?
  end

  def self.categories_code_select
    [['', '']].concat(I18n.backend.send(:translations)[:en][:complaint_category].invert.to_a.sort_by do |key, _value|
                        key
                      end)
  end

  def self.disposition_codes_select
    [['', '']].concat(I18n.backend.send(:translations)[:en][:disposition_code].invert.to_a.sort_by do |key, _value|
                        key
                      end)
  end

  def self.states_select
    [['Open', 'open'], ['In Progress', 'in_progress'], ['Closed', 'closed']]
  end

  def self.severities_select
    [['', ''], ['Non-Emergency', 'non_emergency'], ['Emergency', 'emergency']]
  end
end
