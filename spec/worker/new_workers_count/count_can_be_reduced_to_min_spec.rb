require 'spec_helper'

describe SidekiqAutoscalable::Worker, '#new_workers_count' do
  let(:workers_count) { 6 }

  subject { worker.new_workers_count }

  describe 'workers count can be reduced to min' do
    before do
      allow(worker).to receive(:increase_workers_count?).and_return(false)
      allow(worker).to receive(:reduce_workers_count_to_min?).and_return(true)
    end

    context 'when min workers passed' do
      let(:worker) { described_class.new(worker_name: double,
                                     queues: double,
                                     max_workers: 10,
                                     min_workers: 1) }

      it 'returns min workers' do
        expect(subject).to eq(1)
      end
    end

    context 'when min workers is not passed' do
      let(:worker) { described_class.new(worker_name: double,
                               queues: double,
                               max_workers: 10) }

      it 'returns 0' do
        expect(subject).to eq(0)
      end
    end
  end
end
