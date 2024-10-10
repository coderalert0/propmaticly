# frozen_string_literal: true

FactoryBot.define do
  factory :complaint do
    complaint_id { 'ABC123' }
    filed_date { Time.now }
    description { 'Electrical issues in my living room' }
    category { '56' }
    inspection_date { Time.now - 2.months }
    link { 'http://propmatically.com' }
    state { 0 }
    building
  end
end
