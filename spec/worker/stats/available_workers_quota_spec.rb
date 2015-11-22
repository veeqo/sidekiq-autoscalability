require 'spec_helper'

describe SidekiqAutoscalable::Worker::Stats, '#available_workers_quota' do
  let(:stats) { described_class.new(worker_name: 'test_worker',
                                    queues: double,
                                    max_workers: 25,
                                    quota: double) }

  subject { stats.available_workers_quota }

  before do
    allow(stats).to receive(:workers_count).and_return(workers_count)
  end

  context 'when count of running workers is greater than max workers count' do
    let(:workers_count) { 30 }

    it { is_expected.to eq(0) }
  end

  context 'when count of running workers is less than max workers count' do
    let(:workers_count) { 10 }

    it 'returns subtraction of count of max workers and running workers' do
      is_expected.to eq(15)
    end
  end
end
