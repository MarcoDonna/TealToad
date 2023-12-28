# frozen_string_literal: true

module TealToad
  ##
  # DataFrame is a data structure to store data in a table format.
  # Symbols are used as the names of columns, while Integers are used as row index.
  #
  # @example Initializing a DataFrame
  #   # check #initialize to see how to initialize a DataFrame using different ways.
  #   data_frame = DataFrame.new( data: { first_name: %w[Marco Giovanni], last_name: %w[Some Thing], age: [20, 22] } )
  #
  class DataFrame
    attr_reader :headers, :rows

    ##
    # @example Initializing from an Hash
    #   # no :headers attribute is required, as it is obtained with data.keys.
    #   data = { first_name: %w[Marco Giovanni], last_name: %w[Some Thing], age: [20, 22] }
    #   data_frame = DataFrame.new(data: data)
    #
    # @example Initializing from an Array
    #   headers = %i[first_name last_name age]
    #   data = [['Marco', 'Some', 20], ['Giovanni', 'Thing', 22]]
    #   data_frame = DataFrame.new(headers: headers, data: data)
    #
    # @example Initializing from an Array of Hash
    #   headers = %i[first_name last_name age]
    #   data = [{ first_name: 'Marco', last_name: 'Some', age: 20 },
    #                 { first_name: 'Giovanni', last_name: 'Thing', age: 22 }]
    #   data_frame = DataFrame.new(headers: headers, data: data)
    #
    def initialize(data: nil, headers: nil)
      @headers = headers
      initialize_data data
    end

    private

    ##
    # Wrapper to initialize DataFrame using different shapes of data.
    #
    def initialize_data(data)
      case data
      when nil
        @rows = []
      when Hash
        initialize_data_from_hash data
      when Array
        initialize_data_from_array data
      else
        raise ArgumentError, 'Invalid data when initializing DataFrame'
      end
    end

    ##
    # Wrapper to initialize DataFrame using data stored in an Hash.
    #
    def initialize_data_from_hash(data)
      @headers = data.keys
      @rows = data.values.transpose
    end

    ##
    # Wrapper to initialize DataFrame using data stored in an Array.
    #
    def initialize_data_from_array(data)
      case data[0]
      when Hash
        @rows = data.map do |data_row|
          @headers.map { |key| data_row[key] }
        end
      when Array
        @rows = data
      end
    end
  end
end
