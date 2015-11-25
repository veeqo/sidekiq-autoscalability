require 'active_support/core_ext/module'
require "sidekiq-autoscalable/worker"
require "sidekiq-autoscalable/worker/stats"
require "sidekiq-autoscalable/errors"
require "sidekiq-autoscalable/version"

module SidekiqAutoscalable
  def self.redis
    @redis ||
      raise(SidekiqAutoscalable::Errors::RedisNotDefined, "Connection to redis is not defined")
  end

  def self.redis=(redis)
    @redis = redis
  end
end
