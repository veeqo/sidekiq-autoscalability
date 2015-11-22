require 'spec_helper'

describe SidekiqAutoscalable::Worker::Stats, '#workers_count' do
  let(:stats) { described_class.new(worker_name: 'test_worker',
                                    queues: double,
                                    max_workers: double,
                                    quota: double) }

  let(:redis) { SidekiqAutoscalable.redis }

  subject { stats.workers_count }

  before { SidekiqAutoscalable.redis = Redis.new }

  context 'when there is no sidekiq artefacts in the redis at all' do
    it { is_expected.to eq(0) }
  end

  context 'when there are some workers are running' do
    before do
      add_workers(["test_sidekiq_worker.1:3", "first_test_worker.1:3"])
    end

    context 'when there are no such workers running' do
      it { is_expected.to eq(0) }
    end

    context 'when there are some such workers running' do
      before do
        add_workers(["test_worker.1:3", "test_worker.2:3", "test_worker.3:3"])
      end

      it { is_expected.to eq(3) }
    end
  end

  after { redis.flushall; SidekiqAutoscalable.redis = nil }
end
