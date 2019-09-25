set :output, "log/cron.log"
set :environment, 'development'

job_type :runner,  "cd :path && rvm use 2.6.4 && rails runner -e :environment ':task' :output"
job_type :command, "cd :path && :task :output"

every 24.hours do
  runner "User.steps_reset"
  command "echo 'Steps reset successful!'"
end
