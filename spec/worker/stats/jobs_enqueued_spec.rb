require 'spec_helper'

describe SidekiqAutoscalable::Worker::Stats, '#jobs_enqueued' do
  let(:stats) { described_class.new(worker_name: 'test_worker',
                                    queues: ['queue_1', 'queue_2'],
                                    max_workers: double,
                                    quota: double) }

  let(:redis) { SidekiqAutoscalable.redis }

  subject { stats.jobs_enqueued }

  before do
    SidekiqAutoscalable.redis = Redis.new
    add_job_to_queue('some_queue')
    add_job_to_queue('another_queue')
  end

  context 'when some jobs are enqueued to the passed queues' do
    before do
      2.times { add_job_to_queue('queue_1') }
      3.times { add_job_to_queue('queue_2') }
    end

    it { is_expected.to eq(5) }
  end

  context 'when no any job enqueued to any of passed queues' do
    it { is_expected.to eq(0) }
  end

  after { redis.flushall; SidekiqAutoscalable.redis = nil }
end
