require 'spec_helper'

describe SidekiqAutoscalable::Worker, '#stats' do
  let(:worker) { described_class.new(
    worker_name: 'test_worker',
    queues: ['test_queue_1', 'test_queue_2'],
    max_workers: 5,
    quota: 25,
    threshold: 1
  ) }

  subject { worker.stats }

  it 'is instance of SidekiqAutoscalable::Worker::Stats' do
    expect(subject.class).to eq(SidekiqAutoscalable::Worker::Stats)
  end

  it 'passes correct attributes to SidekiqAutoscalable::Worker::Stats.new' do
    expect(SidekiqAutoscalable::Worker::Stats).to receive(:new).with(
      worker_name: 'test_worker',
      queues: ['test_queue_1', 'test_queue_2'],
      max_workers: 5,
      quota: 25
    )

    subject
  end
end
