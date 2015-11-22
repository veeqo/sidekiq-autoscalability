module SidekiqAutoscalable
  class Worker
    def initialize worker_name:, queues:, max_workers:, quota: 25, threshold: nil
      @worker_name = worker_name
      @queues = queues
      @max_workers = max_workers
      @quota = quota
      @threshold = threshold
    end
    attr_reader :worker_name, :queues, :max_workers, :quota, :threshold

    delegate :available_workers_quota,
             :workers_cover_available_quota,
             :jobs_enqueued,
             :jobs_processing,
             :workers_count, to: :stats

    def increase_workers_count?
      available_workers_quota > 0 && workers_cover_available_quota > 0
    end

    # NOTE: We can't decide which AWS worker to stop,
    # that's why we're waiting until all jobs processed and queue becomes empty
    def reduce_workers_count?
      jobs_enqueued == 0 && jobs_processing == 0
    end

    def new_workers_count
      if increase_workers_count?
        workers_count + increase_workers_by
      elsif reduce_workers_count?
        0
      else
        workers_count
      end
    end

    def stats
      @stats ||= Stats.new(worker_name: worker_name,
                           queues: queues,
                           max_workers: max_workers,
                           quota: quota)
    end

    private

    def increase_workers_by
      threshold ?
        [count_of_workers_can_be_fired, threshold].min :
        count_of_workers_can_be_fired
    end

    def count_of_workers_can_be_fired
      [available_workers_quota, workers_cover_available_quota].min
    end
  end
end