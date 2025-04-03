# frozen_string_literal: true

env :PATH, ENV['PATH']

set :bundle_command, "#{`which bundle`.chomp} exec"
set :output, 'log/cron.log'

every 1.day, at: '12:00 am' do
  runner 'job = Violations::FetchHpdViolationsJob.perform_later; puts "Enqueued #{job.class} (Job ID: #{job.job_id}) to DelayedJob(default)"'
  runner 'job = Inspections::FetchBedBugInspectionsJob.perform_later; puts "Enqueued #{job.class} (Job ID: #{job.job_id}) to DelayedJob(default)"'
  runner 'job = Inspections::FetchBoilerInspectionsJob.perform_later; puts "Enqueued #{job.class} (Job ID: #{job.job_id}) to DelayedJob(default)"'
  runner 'job = Inspections::FetchCoolingTowerInspectionsJob.perform_later; puts "Enqueued #{job.class} (Job ID: #{job.job_id}) to DelayedJob(default)"'
  runner 'job = Inspections::FetchFacadeInspectionsJob.perform_later; puts "Enqueued #{job.class} (Job ID: #{job.job_id}) to DelayedJob(default)"'
  runner 'job = Inspections::FetchElevatorInspectionsJob.perform_later; puts "Enqueued #{job.class} (Job ID: #{job.job_id}) to DelayedJob(default)"'
  runner 'job = Inspections::FetchDrinkingTankInspectionsJob.perform_later; puts "Enqueued #{job.class} (Job ID: #{job.job_id}) to DelayedJob(default)"'

  runner 'job = Complaints::FetchDobComplaintsJob.perform_later(notify: true); puts "Enqueued #{job.class} (Job ID: #{job.job_id}) to DelayedJob(default)"'
  runner 'job = Complaints::FetchHpdComplaintsJob.perform_later(notify: true); puts "Enqueued #{job.class} (Job ID: #{job.job_id}) to DelayedJob(default)"'

  runner 'job = Violations::FetchDobEcbViolationsJob.perform_later(notify: true); puts "Enqueued #{job.class} (Job ID: #{job.job_id}) to DelayedJob(default)"'
  runner 'job = Violations::FetchDobSafetyViolationsJob.perform_later(notify: true); puts "Enqueued #{job.class} (Job ID: #{job.job_id}) to DelayedJob(default)"'
  runner 'job = Violations::FetchDobViolationsJob.perform_later(notify: true); puts "Enqueued #{job.class} (Job ID: #{job.job_id}) to DelayedJob(default)"'
  runner 'job = Violations::FetchHpdViolationsJob.perform_later(notify: true); puts "Enqueued #{job.class} (Job ID: #{job.job_id}) to DelayedJob(default)"'

  runner 'job = CreateUpcomingInspectionsJob.perform_later(notify: true); puts "Enqueued #{job.class} (Job ID: #{job.job_id}) to DelayedJob(default)"'
end
