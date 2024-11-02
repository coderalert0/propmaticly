# frozen_string_literal: true

FactoryBot.define do
  factory :building do
    name { 'The Lombardi' }
    number { '1500' }
    street { 'Pelham Parkway S' }
    city { 'New York' }
    state { 'NY' }
    zip5 { 10_461 }
    portfolio
  end
end
