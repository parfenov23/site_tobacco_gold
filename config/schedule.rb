# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron
require File.expand_path('../..//config/environment.rb', __FILE__)
# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
# every :day, :at => '12pm' do
#   rake "user_notify:overdue_course"
#   rake "user_notify:close_overdue_course"
# end

# every :day, :at => '12pm' do
#   rake "user_notify:payments_account"
# end

# webinar_date = ::Webinar.last.date_start + 5.hour
# webinar_date_s = "50 #{webinar_date.hour} #{webinar_date.day} #{webinar_date.month} * #{webinar_date.year}"
# every webinar_date_s do
#   # command "echo 'you can use raw cron syntax too'"
#   ::Webinar.create
# end