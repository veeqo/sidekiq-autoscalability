module SidekiqAutoscalable
  module Errors
    class SidekiqAutoscalerException < RuntimeError; end

    class RedisNotDefined < SidekiqAutoscalerException; end
  end
end
