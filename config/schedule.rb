# frozen_string_literal: true

# config/schedule.rb

set :output, 'log/cron.log'
set :environment, 'development'

every 1.day, at: '12:00 am' do
  runner 'Inspections::FetchElevatorInspectionsJob.perform_later(nil, true)'
  runner 'Inspections::FetchBedBugInspectionsJob.perform_later(nil, true)'
  runner 'Inspections::FetchBoilerInspectionsJob.perform_later(nil, true)'
  runner 'Inspections::FetchCoolingTowerInspectionsJob.perform_later(nil, true)'
  runner 'Inspections::FetchFacadeInspectionsJob.perform_later(nil, true)'

  runner 'Complaints::FetchDobComplaintsJob.perform_later(nil, true)'
  runner 'Complaints::FetchHpdComplaintsJob.perform_later(nil, true)'

  runner 'Violations::FetchDobEcbViolationsJob.perform_later(nil, true)'
  runner 'Violations::FetchDobSafetyViolationsJob.perform_later(nil, true)'
  runner 'Violations::FetchDobViolationsJob.perform_later(nil, true)'
  runner 'Violations::FetchHpdViolationsJob.perform_later(nil, true)'

  runner 'CreateUpcomingInspectionsJob.perform_later(nil, true)'
end
