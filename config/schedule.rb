set :output, "log/cron.log"
set :environment, "development"

if Rails.env == "development"
  set :output, {error: "log/cron-error.log", standard: "log/cron.log"}
  set :output, "log/cron_log.log"
  set :environment, :development
  env :PATH, ENV['PATH']
end

every 1.minutes do
  runner "User.reset_steps"
end
