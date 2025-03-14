# frozen_string_literal: true

module InspectionRules
  class Facade < InspectionRule
    def tax_block_number
      'tax_block_number % 10'
    end
  end
end
