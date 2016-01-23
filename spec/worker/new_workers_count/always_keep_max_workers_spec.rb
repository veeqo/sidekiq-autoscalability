require 'spec_helper'

describe SidekiqAutoscalable::Worker, '#new_workers_count' do
  let(:worker) { described_class.new(worker_name: double,
                                     queues: double,
                                     max_workers: 10,
                                     always_keep_max_workers: true) }

  subject { worker.new_workers_count }

  describe 'always keep max workers' do
    it 'returns max amount of workers' do
      expect(subject).to eq(10)
    end
  end
end
