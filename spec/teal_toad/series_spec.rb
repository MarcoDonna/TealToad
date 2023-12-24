# frozen_string_literal: true

require 'teal_toad'

describe TealToad::Series do
  subject(:series) { described_class[1, 2, 3, 4, 2, 3] }

  describe '#frequency' do
    it 'returns an hash where the keys are the distinct items in the Series and the values are their count' do
      expect(series.frequency).to eq({ 1 => 1, 2 => 2, 3 => 2, 4 => 1 })
    end
  end

  describe '#mean' do
    it 'returns the average (float) of the items in the Series' do
      expect(series.mean).to eq(2.5)
    end
  end

  describe '#median' do
    it 'returns the median of the Series' do
      expect(series.median).to eq(2.5)
    end
  end

  describe '#mode' do
    it 'returns the mode of the Series' do
      expect(series.mode).to eq([2, 3])
    end
  end

  describe '#range' do
    it 'returns a Range' do
      expect(series.range).to be_a(Range)
    end

    it 'returns a Range between the lowest and highest value in the Series' do
      expect(series.range).to eq(1..4)
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

  describe '#entropy' do
    it 'returns Shannon entropy of the Series' do
      expect(series.entropy).to eq(1.9182958340544893)
    end
  end
end
