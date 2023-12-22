# frozen_string_literal: true

module TealToad
  ##
  # Series are a core data structure in TealToad.
  # Series extend Array adding extra utility and statistics methods.
  #
  #   series = Series[1, 2, 3, 4, 2, 3]
  #   series.freq # => { 1=>1, 2=>2, 3=>2, 4=>1}
  #   series.mean # => 2.5
  #
  class Series < Array
    ##
    # Counts the occurrences of items in the Series.
    #
    # @example
    #   series = Series[1, 2, 3, 4, 2, 3]
    #   series.freq # => { 1=>1, 2=>2, 3=>2, 4=>1}
    #
    # @return [Hash] An hash with the Series distinct items as keys and their count as the values.
    #
    # @see Array#tally
    #
    def frequency
      tally
    end

    ##
    # Returns the probability of the given value in the Series.
    # If smoothing_factor is passed, the probability returned is computed using Laplace smoothing.
    #
    # @example
    #   series = Series[1, 2, 3, 4, 2, 3]
    #   series.probability(3) # => 2/6
    #
    # @params value [BasicObject] Finding probability of this value.
    # @params smoothing_factor [Numeric] Smoothing factor used in Laplace smoothing.
    #
    # @return [Rational] The computed probability
    #
    def probability(value, smoothing_factor: 0)
      Rational(count(value) + smoothing_factor, size + (uniq.size * smoothing_factor))
    end

    alias freq frequency
    alias average mean
    alias avg mean
    alias prob probability
  end
end
