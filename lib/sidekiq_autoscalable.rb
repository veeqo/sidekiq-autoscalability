require 'active_support/core_ext/module'
require "sidekiq_autoscalable/errors"
require "sidekiq_autoscalable/version"

module SidekiqAutoscalable
  def self.redis
    @redis ||
      raise(SidekiqAutoscalable::Errors::RedisNotDefined, "Connection to redis is not defined")
  end

  def self.redis=(redis)
    @redis = redis
  end
end
