# frozen_string_literal: true

FactoryBot.define do
  factory :building do
    street_number { 9631 }
    street_name { 'Scott Rd' }
    city { 'Surrey' }
    administrative_area { 'BC' }
    postal_code { 95_123 }
    email_address { 'gary@surrey.com' }
    sms { '604-582-9799' }
    portfolio
  end
end
