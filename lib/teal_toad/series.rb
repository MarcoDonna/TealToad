# frozen_string_literal: true

module TealToad
  ##
  # Series are a core data structure in TealToad.
  # Series extend Array adding extra utility and statistics methods.
  #
  #   series = Series[1, 2, 3, 4, 2, 3]
  #   series.frequency # => { 1=>1, 2=>2, 3=>2, 4=>1}
  #   series.mean # => 2.5
  #
  class Series < Array
    ##
    # Returns the average of the Series.
    #
    # @return [Rational] The average value.
    #
    def mean
      Rational(sum, size)
    end

    ##
    # Returns the median of the Series.
    #
    # @return [Rational] The median of the Series.
    #
    def median
      sorted = sort
      len = size
      Rational(sorted[(len - 1) / 2] + sorted[len / 2], 2)
    end

    ##
    # Returns the mode of the Series
    #
    # @return [Series] The list of modes.
    #
    def mode
      frequencies_list = frequency
      max_freq = frequencies_list.values.max
      Series[*frequencies_list.select { |_, v| v == max_freq }.keys]
    end

    ##
    # Counts the occurrences of items in the Series.
    #
    # @example
    #   series = Series[1, 2, 3, 4, 2, 3]
    #   series.frequency # => { 1=>1, 2=>2, 3=>2, 4=>1}
    #
    # @return [Hash] An hash with the Series distinct items as keys and their count as the values.
    #
    # @see Array#tally
    #
    def frequency
      tally
    end

    ##
    # @return [Range] like min..max
    #
    # @example
    #   series = Series[1, 2, 3, 4, 2, 3]
    #   series.range # => 1..4
    #
    def range
      Range.new(min, max)
    end

    ##
    # @return [Rational] the Variance of the Series
    #
    def variance
      mean_value = mean
      Rational(inject(0) { |acc, value| acc + ((value - mean_value)**2) }, size)
    end

    ##
    # @return [Float] the Standard Deviation of the Series
    #
    def standard_deviation
      Math.sqrt(variance)
    end

    ##
    # Returns the probability of the given value in the Series.
    # If smoothing_factor is passed, the probability returned is computed using Laplace smoothing.
    #
    # @example
    #   series = Series[1, 2, 3, 4, 2, 3]
    #   series.probability(3) # => 2/6
    #   series.probability(3, smoothing_factor: 1) # => 3/10
    #   series.probability(-2, smoothing_factor: 1) # => 1/10
    #
    # @param value [BasicObject] Finding probability of this value.
    # @param smoothing_factor [Numeric] Smoothing factor used in Laplace smoothing.
    #
    # @return [Rational] The computed probability
    #
    def probability(value, smoothing_factor: 0)
      Rational(count(value) + smoothing_factor, size + (uniq.size * smoothing_factor))
    end

    ##
    # @return [Float] Shannon entropy of the Series.
    #
    def entropy
      - frequency.values.inject(0) do |acc, count|
        prob = Rational(count, size)
        acc + (prob * Math.log2(prob))
      end
    end
  end
end
