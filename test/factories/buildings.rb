# frozen_string_literal: true

FactoryBot.define do
  factory :building do
    name { 'The Lombardi' }
    address1 { '9631 Scott Rd' }
    city { 'Surrey' }
    state { 'BC' }
    zip5 { 95123 }
    email_address { 'gary@surrey.com' }
    sms { '604-582-9799' }
    portfolio
  end
end
