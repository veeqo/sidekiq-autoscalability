require 'spec_helper'

describe SidekiqAutoscalable::Worker::Stats, '#workers_cover_available_quota' do
  let(:stats) { described_class.new(worker_name: 'test_worker',
                                    queues: double,
                                    max_workers: 25,
                                    quota: 25) }

  subject { stats.workers_cover_available_quota }

  before do
    allow(stats).to receive(:jobs_enqueued).and_return(jobs_enqueued)
  end

  context 'when count of enqueued jobs is greater than jobs quota' do
    let(:jobs_enqueued) { 30 }

    it 'returns smallest integer more or eq to result of (jobs enqueued / quota)' do
      is_expected.to eq(2)
    end
  end

  context 'when count of enqueued jobs is less than jobs quota' do
    let(:jobs_enqueued) { 10 }

    it 'returns smallest integer more or eq to result of (jobs enqueued / quota)' do
      is_expected.to eq(1)
    end
  end
end
