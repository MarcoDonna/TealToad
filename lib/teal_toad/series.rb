# frozen_string_literal: true

module TealToad
  ##
  # Series are a core data structure in TealToad.
  # Series extend Array adding extra utility and statistics methods.
  #
  #   series = Series[1, 2, 3, 4, 2, 3]
  #   series.freq # => { 1=>1, 2=>2, 3=>2, 4=>1}
  #   series.mean # =>
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

    alias freq frequency
  end
end
