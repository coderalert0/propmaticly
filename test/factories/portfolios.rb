# frozen_string_literal: true

FactoryBot.define do
  factory :portfolio do
    name { 'Acme' }
    description { 'A fictional corporation that features prominently in the Road Runner/Wile E. Coyote series' }
    email_address { 'acme@portfolio.com' }
    sms { '925-989-0000' }
    organization
  end
end
