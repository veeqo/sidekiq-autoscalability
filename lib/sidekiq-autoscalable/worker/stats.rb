module SidekiqAutoscalable
  class Worker::Stats
    def initialize worker_name:, queues:, max_workers:, quota: 25
      @worker_name = worker_name
      @queues = queues
      @max_workers = max_workers
      @quota = quota
    end
    attr_reader :worker_name, :queues, :max_workers, :quota

    def jobs_enqueued
      @jobs_enqueued ||= queues.map do |queue|
        redis.llen("queue:#{queue}")
      end.inject(0, :+)
    end

    def jobs_processing
      @jobs_processing ||= current_workers.map do |current_worker|
        redis.hget(current_worker, 'busy').to_i
      end.inject(0, :+)
    end

    def workers_count
      current_workers.count
    end

    def current_workers
      @current_workers ||= all_workers.select { |worker| worker.match(/^#{worker_name}/) }
    end

    def all_workers
      redis.smembers('processes')
    end

    def available_workers_quota
      @available_workers_quota ||= [(max_workers - workers_count), 0].max
    end

    def workers_cover_available_quota
      @workers_cover_available_quota ||= (jobs_enqueued / quota.to_f).ceil
    end

    def workers_cover_current_jobs
      @workers_cover_current_jobs ||= ((jobs_enqueued + jobs_processing) / quota.to_f).ceil
    end

    def to_h
      [ :jobs_enqueued,
        :jobs_processing,
        :workers_count,
        :available_workers_quota,
        :workers_cover_available_quota ].inject({}) do |stats_hash, key|
          stats_hash.merge({ key => send(key) })
      end
    end

    def redis
      SidekiqAutoscalable.redis
    end
  end
end
