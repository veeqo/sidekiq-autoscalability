require 'spec_helper'

describe SidekiqAutoscalable::Worker, '#need_to_update_workers_count?' do
  let(:worker) { described_class.new(worker_name: double,
                                     queues: double,
                                     max_workers: 10) }

  subject { worker.need_to_update_workers_count? }

  context 'when current count of workers equals to calculated new workers count' do
    before do
      allow(worker).to receive(:workers_count).and_return(10)
      allow(worker).to receive(:new_workers_count).and_return(10)
    end

    it { is_expected.to be_falsey }
  end

  context 'when current count of workers does not equal to new workers count' do
    before do
      allow(worker).to receive(:workers_count).and_return(10)
      allow(worker).to receive(:new_workers_count).and_return(5)
    end

    it { is_expected.to be_truthy }
  end
end
