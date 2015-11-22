require 'spec_helper'

describe SidekiqAutoscalable::Worker, '#new_workers_count' do
  let(:worker) { described_class.new(worker_name: double,
                                     queues: double,
                                     max_workers: 10) }
  let(:workers_count) { 6 }

  subject { worker.new_workers_count }

  describe 'workers count can be reduced' do
    before do
      allow(worker).to receive(:increase_workers_count?).and_return(false)
      allow(worker).to receive(:reduce_workers_count?).and_return(true)
    end

    it 'returns 0' do
      expect(subject).to eq(0)
    end
  end
end
