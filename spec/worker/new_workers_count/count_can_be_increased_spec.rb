require 'spec_helper'

describe SidekiqAutoscalable::Worker, '#new_workers_count' do
  let(:worker) { described_class.new(worker_name: double,
                                     queues: double,
                                     max_workers: 10,
                                     threshold: threshold) }
  let(:workers_count) { 6 }

  subject { worker.new_workers_count }

  context 'when workers count can be increased' do
    before do
      allow(worker).to receive(:increase_workers_count?).and_return(true)
      allow_any_instance_of(SidekiqAutoscalable::Worker::Stats).to receive(:workers_count).and_return(6)
    end

    context 'when threshold is passed' do
      context 'when available workers quota is less than count of workers can process enqueued jobs' do
        before do
          allow_any_instance_of(SidekiqAutoscalable::Worker::Stats).
            to receive(:available_workers_quota).and_return(2)

          allow_any_instance_of(SidekiqAutoscalable::Worker::Stats).
            to receive(:workers_cover_available_quota).and_return(6)
        end

        context 'when available workers quota is less than threshold' do
          let(:threshold) { 5 }

          it 'returns sum of available workers quota and current workers count' do
            expect(subject).to eq(8)
          end
        end

        context 'when available workers quota is greater than threshold' do
          let(:threshold) { 1 }

          it 'returns sum of threshold and current workers count' do
            expect(subject).to eq(7)
          end
        end
      end

      context 'when availble workers quota is greater than count of workers can process enqueued jobs' do
        before do
          allow_any_instance_of(SidekiqAutoscalable::Worker::Stats).
            to receive(:available_workers_quota).and_return(6)

          allow_any_instance_of(SidekiqAutoscalable::Worker::Stats).
            to receive(:workers_cover_available_quota).and_return(4)
        end

        context 'when count of workers can process jobs is less than threshold' do
          let(:threshold) { 5 }

          it 'returns sum of count of workers can process jobs and current workers count' do
            expect(subject).to eq(10)
          end
        end

        context 'when count of workers can process jobs is greater than threshold' do
          let(:threshold) { 1 }

          it 'returns sum of threshold and current workers count' do
            expect(subject).to eq(7)
          end
        end
      end
    end

    context 'when threshold is not passed' do
      let(:threshold) { nil }

      context 'when available workers quota is less than count of workers can process enqueued jobs' do
        before do
          allow_any_instance_of(SidekiqAutoscalable::Worker::Stats).
            to receive(:available_workers_quota).and_return(4)

          allow_any_instance_of(SidekiqAutoscalable::Worker::Stats).
            to receive(:workers_cover_available_quota).and_return(6)
        end

        it 'returns sum of available workers quota and current workers count' do
          expect(subject).to eq(10)
        end
      end

      context 'when availble workers quota is greater than count of workers can process enqueued jobs' do
        before do
          allow_any_instance_of(SidekiqAutoscalable::Worker::Stats).
            to receive(:available_workers_quota).and_return(6)

          allow_any_instance_of(SidekiqAutoscalable::Worker::Stats).
            to receive(:workers_cover_available_quota).and_return(2)
        end

        it 'returns sum of count of workers can process jobs and current workers count' do
          expect(subject).to eq(8)
        end
      end
    end
  end
end
