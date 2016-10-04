require "resque/failure/multiple"
require "resque/failure/redis"
require "resque/failure/notification"

module Sufia
  class ResqueAdmin
    def self.matches?(request)
      current_user = request.env['warden'].user
      return false if current_user.blank?
      # TODO code a group here that makes sense
      #current_user.groups.include? 'umg/up.dlt.scholarsphere-admin'
    end
  end
end


config = YAML::load(ERB.new(IO.read(File.join(Rails.root, 'config', 'redis.yml'))).result)[Rails.env].with_indifferent_access
Resque.redis = Redis.new(host: config[:host], port: config[:port], thread_safe: true)

Resque.inline = Rails.env.test?
#Resque.redis.namespace = "#{Sufia.config.redis_namespace}:#{Rails.env}"


Resque::Failure::Notifier.configure do |config|
  config.from = ENV['RESQUE_NOTIFIER_FROM'] ||= "#{ENV['USER']}@#{Socket.gethostname}"
  config.to = ENV['RESQUE_NOTIFIER_TO']
end

Resque::Failure::Multiple.configure do |multi|
  # Always stores failure in Redis and writes to log
  multi.classes = Resque::Failure::Redis, Resque::Failure::Logger
  # Production only: also email us a notification
  multi.classes << Resque::Failure::Notifier #if Rails.env.production?
end
