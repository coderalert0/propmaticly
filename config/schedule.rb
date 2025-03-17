# frozen_string_literal: true

# config/schedule.rb

set :output, 'log/cron.log'
set :environment, 'development'

every 1.day, at: '12:00 am' do
  runner 'Inspections::FetchElevatorInspectionsJob.perform_later(notify: true)'
  runner 'Inspections::FetchBedBugInspectionsJob.perform_later(notify: true)'
  runner 'Inspections::FetchBoilerInspectionsJob.perform_later(notify: true)'
  runner 'Inspections::FetchCoolingTowerInspectionsJob.perform_later(notify: true)'
  runner 'Inspections::FetchFacadeInspectionsJob.perform_later(notify: true)'

  runner 'Complaints::FetchDobComplaintsJob.perform_later(notify: true)'
  runner 'Complaints::FetchHpdComplaintsJob.perform_later(notify: true)'

  runner 'Violations::FetchDobEcbViolationsJob.perform_later(notify: true)'
  runner 'Violations::FetchDobSafetyViolationsJob.perform_later(notify: true)'
  runner 'Violations::FetchDobViolationsJob.perform_later(notify: true)'
  runner 'Violations::FetchHpdViolationsJob.perform_later(notify: true)'

  runner 'CreateUpcomingInspectionsJob.perform_later'
end
