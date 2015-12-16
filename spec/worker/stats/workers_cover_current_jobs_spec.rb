require 'spec_helper'

describe SidekiqAutoscalable::Worker::Stats, '#workers_cover_current_jobs' do
  let(:stats) { described_class.new(worker_name: 'test_worker',
                                    queues: double,
                                    max_workers: 25,
                                    quota: 25) }

  subject { stats.workers_cover_current_jobs }

  before do
    allow(stats).to receive(:jobs_enqueued).and_return(jobs_enqueued)
    allow(stats).to receive(:jobs_processing).and_return(jobs_processing)
  end

  context 'when sum of jobs is greater than jobs quota' do
    let(:jobs_enqueued) { 20 }
    let(:jobs_processing) { 10 }

    it 'returns smallest integer more or eq to result of (jobs enqueued + jobs_processing / quota)' do
      is_expected.to eq(2)
    end
  end

  context 'when sum of jobs is less than jobs quota' do
    let(:jobs_enqueued) { 10 }
    let(:jobs_processing) { 10 }

    it 'returns smallest integer more or eq to result of (jobs enqueued + jobs_processing / quota)' do
      is_expected.to eq(1)
    end
  end
end
