require 'spec_helper'

describe SidekiqAutoscalable::Worker, '#increase_workers_count?' do
  let(:worker) { described_class.new(worker_name: double,
                                     queues: double,
                                     max_workers: 10) }

  subject { worker.increase_workers_count? }

  context 'when count of running workers is greater than maximum' do
    before { allow_any_instance_of(SidekiqAutoscalable::Worker::Stats).to receive(:workers_count).and_return(11) }

    it { is_expected.to be_falsey }
  end

  context 'when count of running workers equals to maximum amount of workers' do
    before { allow_any_instance_of(SidekiqAutoscalable::Worker::Stats).to receive(:workers_count).and_return(10) }

    it { is_expected.to be_falsey }
  end

  context 'when count of running workers is less than maximum' do
    before { allow_any_instance_of(SidekiqAutoscalable::Worker::Stats).to receive(:workers_count).and_return(2) }

    context 'when count of workers which can cover available quota is 0' do
      before { allow_any_instance_of(SidekiqAutoscalable::Worker::Stats).to receive(:workers_cover_available_quota).and_return(0) }

      it { is_expected.to be_falsey }
    end

    context 'when count of workers which can cover available quota is greater than 0' do
      before { allow_any_instance_of(SidekiqAutoscalable::Worker::Stats).to receive(:workers_cover_available_quota).and_return(2) }

      it { is_expected.to be_truthy }
    end
  end
end
