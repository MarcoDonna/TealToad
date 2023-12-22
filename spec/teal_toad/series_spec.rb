# frozen_string_literal: true

require 'teal_toad'

describe TealToad::Series do
  subject(:series) { described_class[1, 2, 3, 4, 2, 3] }

  describe '#freq' do
    it 'returns an hash where the keys are the distinct items in the Series and the values are their count' do
      expect(series.freq).to eq({ 1 => 1, 2 => 2, 3 => 2, 4 => 1 })
    end
  end

  describe '#mean' do
    it 'returns the average (float) of the items in the Series' do
      expect(series.mean).to eq(2.5)
    end
  end

  describe '#probability' do
    it 'returns the probability of the given value in the Series' do
      expect(series.probability(3)).to eq(Rational(2, 6))
    end

    it 'returns the laplace smoothe probability if smoothing_factor: is passed' do
      expect(series.probability(3, smoothing_factor: 1)).to eq(Rational(3, 10))
    end

    it 'returns the laplace smoothed probability even when the given item doesn\t appear in the series' do
      expect(series.probability(-1, smoothing_factor: 1)).to eq(Rational(1, 10))
    end
  end
end
