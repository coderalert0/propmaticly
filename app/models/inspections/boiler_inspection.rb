# frozen_string_literal: true

module Inspections
  class BoilerInspection < ApplicationRecord
    belongs_to :building
    belongs_to :inspection_rule
  end
end
