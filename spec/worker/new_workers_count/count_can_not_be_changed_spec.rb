require 'spec_helper'

describe SidekiqAutoscalable::Worker, '#new_workers_count' do
  let(:worker) { described_class.new(worker_name: double,
                                     queues: double,
                                     max_workers: 10) }
  let(:workers_count) { 6 }

  subject { worker.new_workers_count }

  describe 'workers count can not be reduced or increased' do
    before do
      allow(worker).to receive(:increase_workers_count?).and_return(false)
      allow(worker).to receive(:reduce_workers_count?).and_return(false)
      allow_any_instance_of(SidekiqAutoscalable::Worker::Stats).to receive(:workers_count).and_return(6)
    end

    it 'returns current amount of workers' do
      expect(subject).to eq(workers_count)
    end
  end
end
