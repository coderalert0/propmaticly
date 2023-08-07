FactoryBot.define do
  factory :complaint do
    complaint_id { 'ABC123' }
    filed_date { Time.now }
    description { 'Electrical issues in my living room' }
    status { 'Open' }
    category { 'Electrical' }
    last_inspection_date { Time.now - 2.months }
    link { 'http://propmatically.com' }
    state { 0 }
    building
  end
end