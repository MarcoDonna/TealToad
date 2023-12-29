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
    include Enumerable

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

    ##
    # Yields each row in an hash syntax {column_name: value, ...}.
    # Allows the use of other Enumerable methods like #map and #inject.
    #
    # @todo return DataFrame instead of Hash
    #
    def each
      rows.each { |row| yield(row_to_hash(row)) }
    end

    ##
    # Retrieve data stored in the DataFrame.
    #
    # @param key [Symbol, Numeric, Range, Array]
    #
    # @example Accessing columns
    #   data = { first_name: %w[Marco Giovanni Alice Marco],
    #            last_name: %w[Some Thing Else Qwerty],
    #            age: [20, 22, 24, 32] }
    #   data_frame = DataFrame.new(data: data)
    #   data_frame[:first_name] # => Series, containing all first names in the DataFrame.
    #   data_frame[[:first_name, :age]] # => DataFrame, containing the first names and ages.
    #
    # @example Accessing rows
    #   data = { first_name: %w[Marco Giovanni Alice Marco],
    #            last_name: %w[Some Thing Else Qwerty],
    #            age: [20, 22, 24, 32] }
    #   data_frame = DataFrame.new(data: data)
    #   data_frame[0] # => DataFrame, containing the records at the specified index of the DataFrame.
    #   data_frame[0..2] # => DataFrame, containing the records in the given range.
    #   data_frame[[0, 2]] # => DataFrame, containing the records at the given indexes.
    #
    def [](key)
      case key
      when Symbol
        column key
      when Numeric
        row key
      when Range
        range_rows key
      when Array
        case key[0]
        when Symbol
          list_columns key
        when Numeric
          list_rows key
        end
      else
        raise ArgumentError, 'Invalid key when accessing data in DataFrame'
      end
    end

    ##
    # @return [Numeric] The number of rows in the DataFrame.
    #
    def size
      rows.size
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

    def row_to_hash(row)
      headers.zip(row).to_h
    end

    def column(column_name)
      Series[*map { |row| row[column_name] }] if headers.include? column_name
    end

    def list_columns(column_name_list)
      column_name_list &= headers
      data = rows.map do |row|
        column_name_list.map { |column_name| row_to_hash(row)[column_name] }
      end
      DataFrame.new(headers: column_name_list, data: data)
    end

    def row(index)
      DataFrame.new(headers: headers, data: [rows[index]]) if (-size..(size - 1)).cover? index
    end

    def range_rows(range)
      DataFrame.new(headers: headers, data: rows[range])
    end

    def list_rows(index_list)
      index_list = index_list.select { |index| (-size..(size - 1)).cover? index }
      data = index_list.map { |index| rows[index] }
      DataFrame.new(headers: headers, data: data)
    end
  end
end
