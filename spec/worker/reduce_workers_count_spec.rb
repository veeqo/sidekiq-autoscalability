require 'spec_helper'

describe SidekiqAutoscalable::Worker, '#reduce_workers_count?' do
  let(:worker) { described_class.new(worker_name: double,
                                     queues: double,
                                     max_workers: 10) }

  subject { worker.reduce_workers_count? }

  context 'when count of enqueued jobs is greater than 0' do
    before { allow_any_instance_of(SidekiqAutoscalable::Worker::Stats).to receive(:jobs_enqueued).and_return(1) }

    it { is_expected.to be_falsey }
  end

  context 'when count of enqueued jobs is 0' do
    before { allow_any_instance_of(SidekiqAutoscalable::Worker::Stats).to receive(:jobs_enqueued).and_return(0) }

    context 'when count of processing jobs is greater than 0' do
      before { allow_any_instance_of(SidekiqAutoscalable::Worker::Stats).to receive(:jobs_processing).and_return(1) }

      it { is_expected.to be_falsey }
    end

    context 'when count of processing jobs is 0' do
      before { allow_any_instance_of(SidekiqAutoscalable::Worker::Stats).to receive(:jobs_processing).and_return(0) }

      it { is_expected.to be_truthy }
    end
  end
end
