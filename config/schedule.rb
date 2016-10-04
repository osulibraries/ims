# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

set :output, "#{path}/log/cron.log"

every 15.minutes do
  command "RAILS_ENV=#{@environment} #{path}/lib/support/resque-check.sh"
end

every 5.minutes do
  command "RAILS_ENV=#{@environment} #{path}/lib/support/resque-recovery.sh"
end
