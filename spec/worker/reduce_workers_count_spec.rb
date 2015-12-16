require 'spec_helper'

describe SidekiqAutoscalable::Worker, '#reduce_workers_count_to_min?' do
  let(:worker) { described_class.new(worker_name: double,
                                     queues: double,
                                     max_workers: 10,
                                     reduce_only_to_min: reduce_only_to_min) }

  subject { worker.reduce_workers_count_to_min? }

  context 'when reduce_only_to_min is false' do
    let(:reduce_only_to_min) { false }

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

        it { is_expected.to be_falsey }
      end
    end
  end

  context 'when reduce_only_to_min is true' do
    let(:reduce_only_to_min) { true }

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
end
