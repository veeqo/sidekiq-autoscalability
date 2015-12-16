require 'spec_helper'

describe SidekiqAutoscalable::Worker, '#new_workers_count' do
  let(:workers_count) { 6 }

  subject { worker.new_workers_count }

  describe 'workers count can be reduced to reasonable amount' do
    let(:worker) { described_class.new(worker_name: double,
                                   queues: double,
                                   max_workers: 10,
                                   min_workers: 2) }

    before do
      allow(worker).to receive(:increase_workers_count?).and_return(false)
      allow(worker).to receive(:reduce_workers_count_to_min?).and_return(false)
      allow(worker).to receive(:reduce_workers_count_to_reasonable?).and_return(true)
    end

    context 'when min amount of workers is greater than amount of workers can cover current jobs' do
      before do
        allow(worker).to receive(:workers_cover_current_jobs).and_return(1)
      end

      it 'returns min amount of workers' do
        is_expected.to eq(2)
      end
    end

    context 'when min amount of workers is lower than amount of workers can cover current jobs' do
      before do
        allow(worker).to receive(:workers_cover_current_jobs).and_return(4)
      end

      it 'returns amount of workers can cover current jobs' do
        is_expected.to eq(4)
      end
    end
  end
end
