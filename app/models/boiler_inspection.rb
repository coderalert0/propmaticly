# frozen_string_literal: true

class BoilerInspection < ApplicationRecord
  belongs_to :building
  belongs_to :inspection_rule
end
