# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

InspectionRule.create(compliance_item: :facade, frequency_in_months: 60, number_of_stories_operator: '>', number_of_stories_value: 6, description: 'Facade Inspection Safety Program (FISP), formerly known as Local Law 11, requires periodic inspections of building facades to ensure safety and compliance. This applies to buildings taller than six stories.', )

InspectionRule.create(compliance_item: :elevator, frequency_in_months: 12, has_elevator: true, description: 'Category One (Cat-1) Elevator Inspection Report is an annual inspection requirement for all elevators and similar devices, such as escalators and other lifting devices. This inspection ensures elevators comply with safety standards and regulations.')
InspectionRule.create(compliance_item: :elevator, frequency_in_months: 36, has_elevator: true, description: 'Category Three (Cat-3) elevator inspection specifically required for water hydraulic elevators. This inspection ensures that hydraulic systems in these elevators are functioning safely, as hydraulic elevators operate differently than traction (cable-driven) elevators and require specialized attention.')
InspectionRule.create(compliance_item: :elevator, frequency_in_months: 60, has_elevator: true, description: 'Category Five (CAT5) elevator inspection is a comprehensive safety test mandated to ensure the safe operation of elevators. This inspection involves testing the elevator at its rated load and speed to verify that all safety mechanisms function correctly under full operational conditions.')

InspectionRule.create(compliance_item: :sprinkler_system, frequency_in_months: 1, has_sprinklers: true, description: 'Monthly sprinkler system inspection ensures that key components of the sprinkler system are visually checked for any signs of damage, obstruction, or tampering.')
InspectionRule.create(compliance_item: :sprinkler_system, frequency_in_months: 3, has_sprinklers: true, description: 'Quarterly sprinkler system inspection includes all monthly checks but involves additional functional tests to verify that specific operational components are working correctly.')
InspectionRule.create(compliance_item: :sprinkler_system, frequency_in_months: 12, has_sprinklers: true, description: 'Annual sprinkler system inspection is a comprehensive review of the entire sprinkler system, covering all components in detail to confirm that the system operates as expected.')
InspectionRule.create(compliance_item: :sprinkler_system, frequency_in_months: 60, has_sprinklers: true, description: '5-Year sprinkler system inspection is a thorough check of the internal condition of the sprinkler piping to detect any corrosion, blockages, or other issues that could hinder water flow.')

InspectionRule.create(compliance_item: :standpipe_system, frequency_in_months: 1, has_standpipe: true, description: 'Monthly Standpipe System inspection is a basic, visual check to ensure that all accessible components of the standpipe system are in good condition and ready for use.')
InspectionRule.create(compliance_item: :standpipe_system, frequency_in_months: 12, has_standpipe: true, description: 'Annual Standpipe System inspection is a more thorough evaluation of the standpipe system, covering all aspects of the system to ensure operational readiness.')
InspectionRule.create(compliance_item: :standpipe_system, frequency_in_months: 60, has_standpipe: true, description: '5-Year Standpipe System inspection is an in-depth evaluation of the internal and operational condition of the standpipe system. This inspection aims to identify hidden issues, such as internal corrosion or obstructions, that could impair water flow during a fire.')

InspectionRule.create(compliance_item: :backflow_prevention, frequency_in_months: 12, has_backflow: true, description: 'Backflow Prevention Inspection Report is required for buildings with backflow prevention devices. These devices prevent contaminated water from flowing back into the public water supply, ensuring the safety of drinking water.')

InspectionRule.create(compliance_item: :cooling_tower, frequency_in_months: 1, has_cooling_tower: true, description: 'Monthly Cooling Tower Inspection Report focuses on maintaining water quality and controlling Legionella growth by monitoring chemical levels and general system conditions.')
InspectionRule.create(compliance_item: :cooling_tower, frequency_in_months: 3, has_cooling_tower: true, description: 'Quarterly Cooling Tower Inspection Report is a more comprehensive inspection than the monthly check, focusing on key operational and safety components of the cooling tower system.')
InspectionRule.create(compliance_item: :cooling_tower, frequency_in_months: 12, has_cooling_tower: true, description: 'Annual Cooling Tower Inspection Report is a complete assessment of the cooling tower system, verifying compliance with NYC health regulations and providing certification that all required maintenance has been performed.')

InspectionRule.create(compliance_item: :bed_bug, frequency_in_months: 12, number_of_residential_units_operator: '>=' ,number_of_residential_units_value: 3, description: 'Annual Bed Bug Inspection Report is a requirement to document bed bug infestations and inspection outcomes. Building owners of certain residential properties report on bed bug infestations annually. The report is required for multi-family residential buildings (buildings with three or more units).')
InspectionRule.create(compliance_item: :window_guard, frequency_in_months: 12, units_with_children_age_operator: '<=', units_with_children_age_value: 10, description: 'Window Guard Inspection Report is a requirement for building owners to ensure that window guards are properly installed in apartments where young children (under age 11) reside. This mandate is part of efforts to prevent accidents involving children falling from windows.')
InspectionRule.create(compliance_item: :energy_efficiency_ratings, frequency_in_months: 12, square_feet_operator: '>=', square_feet_value: 25_000, description: 'Energy Efficiency Ratings Inspection is aimed at promoting energy efficiency and sustainability in buildings. This mandate requires certain buildings to measure their energy performance, receive a rating, and display this information publicly.')




