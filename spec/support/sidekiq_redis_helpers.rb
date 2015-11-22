module SidekiqRedisHelpers
  def add_workers(worker_names)
    worker_names.each do |worker_name|
      add_worker(worker_name)
    end
  end

  def add_worker(worker_name)
    redis.sadd('processes', worker_name)
  end

  def add_jobs_to_worker(worker_name, number_of_jobs)
    redis.hset(worker_name, "busy", number_of_jobs)
  end

  def add_job_to_queue(queue)
    redis.lpush("queue:#{queue}", job_in(queue))
  end

  def job_in(queue)
    "{\"retry\":false,\"queue\":\"#{queue}\",\"backtrace\":true,\"expiration\":259200,\"unique\":\"all\",\"expiration\":86400,\"class\":\"SomeWorker\",\"args\":[#{rand(10)}]}"
  end
end
