# frozen_string_literal: true

module Inspections
  class ElevatorInspection < ApplicationRecord
    belongs_to :building
    belongs_to :inspection_rule
  end
end
