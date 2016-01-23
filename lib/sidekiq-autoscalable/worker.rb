module SidekiqAutoscalable
  class Worker
    def initialize worker_name:, queues:, max_workers:, min_workers: 0, quota: 25, threshold: nil, reduce_only_to_min: true, always_keep_max_workers: false
      @worker_name = worker_name
      @queues = queues
      @max_workers = max_workers
      @min_workers = min_workers
      @quota = quota
      @threshold = threshold
      @reduce_only_to_min = reduce_only_to_min
      @always_keep_max_workers = always_keep_max_workers
    end
    attr_reader :worker_name, :queues, :max_workers, :min_workers, :quota, :threshold, :reduce_only_to_min, :always_keep_max_workers

    delegate :available_workers_quota,
             :workers_cover_available_quota,
             :jobs_enqueued,
             :jobs_processing,
             :workers_count,
             :workers_cover_current_jobs, to: :stats

    def increase_workers_count?
      available_workers_quota > 0 && workers_cover_available_quota > 0
    end

    def reduce_workers_count_to_min?
      all_jobs_processed? && reduce_only_to_min
    end

    def reduce_workers_count_to_reasonable?
      workers_count_can_be_reduced? && !reduce_only_to_min
    end

    def new_workers_count
      if always_keep_max_workers
        max_workers

      elsif increase_workers_count?
        workers_count + increase_workers_by

      elsif reduce_workers_count_to_min?
        min_workers

      elsif reduce_workers_count_to_reasonable?
        count_of_workers_can_be_left

      else
        workers_count
      end
    end

    def need_to_update_workers_count?
      new_workers_count != workers_count
    end

    def stats
      @stats ||= Stats.new(worker_name: worker_name,
                           queues: queues,
                           max_workers: max_workers,
                           quota: quota)
    end

    private

    def all_jobs_processed?
      jobs_enqueued == 0 && jobs_processing == 0
    end

    def workers_count_can_be_reduced?
      workers_cover_current_jobs < workers_count
    end

    def increase_workers_by
      threshold ?
        [count_of_workers_can_be_fired, threshold].min :
        count_of_workers_can_be_fired
    end

    def count_of_workers_can_be_fired
      [available_workers_quota, workers_cover_available_quota].min
    end

    def count_of_workers_can_be_left
      [min_workers, workers_cover_current_jobs].max
    end
  end
end
