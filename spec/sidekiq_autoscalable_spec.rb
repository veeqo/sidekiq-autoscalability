require 'spec_helper'

describe SidekiqAutoscalable, '#redis' do
  subject { SidekiqAutoscalable.redis }

  context 'when redis is not defined' do
    it 'raises SidekiqAutoscalable::Errors::RedisNotDefined exception' do
      expect { subject }.to raise_error(SidekiqAutoscalable::Errors::RedisNotDefined)
    end
  end

  context 'when redis is defined' do
    before { SidekiqAutoscalable.redis = Redis.new }

    it 'returns redis connection instance' do
      expect(subject.class).to eq(Redis)
    end

    after { SidekiqAutoscalable.redis = nil }
  end
end
