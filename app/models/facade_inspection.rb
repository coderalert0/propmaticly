# frozen_string_literal: true

class FacadeInspection < ApplicationRecord
  belongs_to :building
  belongs_to :inspection_rule
end
