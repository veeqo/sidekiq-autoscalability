require 'spec_helper'

describe SidekiqAutoscalable::Worker::Stats, '#jobs_processing' do
  let(:stats) { described_class.new(worker_name: 'test_worker',
                                    queues: double,
                                    max_workers: double,
                                    quota: double) }

  let(:redis) { SidekiqAutoscalable.redis }

  subject { stats.jobs_processing }

  before do
    SidekiqAutoscalable.redis = Redis.new
    add_workers(["test_sidekiq_worker.1:3", "another_test_worker.1:3"])
  end

  context 'when there is no such worker running' do
    it { is_expected.to eq(0) }
  end

  context 'when some workers are running' do
    before do
      add_workers(["test_worker.1:3", "test_worker.2:3"])
      add_jobs_to_worker("test_worker.1:3", '1')
      add_jobs_to_worker("test_worker.2:3", '10')
    end

    it { is_expected.to eq(11) }
  end

  after { redis.flushall; SidekiqAutoscalable.redis = nil }
end
