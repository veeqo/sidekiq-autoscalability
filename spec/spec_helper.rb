$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
Dir[File.join(__dir__, "support/**/*.rb")].each { |f| require f }

require 'sidekiq-autoscalable'
require 'byebug'
require 'fakeredis'

include SidekiqRedisHelpers
