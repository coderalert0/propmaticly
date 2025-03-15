# frozen_string_literal: true

# config/schedule.rb

set :output, 'log/cron.log'
set :environment, 'development'

every 1.day, at: '12:00 am' do
  runner 'Inspections::FetchElevatorInspectionsJob.perform_later'
  runner 'Inspections::FetchBedBugInspectionsJob.perform_later'
  runner 'Inspections::FetchBoilerInspectionsJob.perform_later'
  runner 'Inspections::FetchCoolingTowerInspectionsJob.perform_later'
  runner 'Inspections::FetchFacadeInspectionsJob.perform_later'

  runner 'Complaints::FetchDobComplaintsJob.perform_later'
  runner 'Complaints::FetchHpdComplaintsJob.perform_later'

  runner 'Violations::FetchDobEcbViolationsJob.perform_later'
  runner 'Violations::FetchDobSafetyViolationsJob.perform_later'
  runner 'Violations::FetchDobViolationsJob.perform_later'
  runner 'Violations::FetchHpdViolationsJob.perform_later'

  runner 'CreateUpcomingInspectionsJob.perform_later'
end
