# frozen_string_literal: true

class Lead < ApplicationRecord
  validates :entity_name, :process_address, :process_city, :process_zip_code, :penalty_imposed, presence: true
end
