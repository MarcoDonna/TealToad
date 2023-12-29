# frozen_string_literal: true

require 'teal_toad'

describe TealToad::DataFrame do
  context 'when initializing a DataFrame' do
    let :expected_rows do
      [['Marco', 'Some', 20], ['Giovanni', 'Thing', 22]]
    end

    context 'when initializing a empty DataFrame' do
      it 'creates an empty DataFrame' do
        expect(described_class.new(headers: %i[first_name last_name age]).rows).to eq([])
      end
    end

    context 'when initialized using an Hash' do
      subject :instance_from_hash do
        hash_data = { first_name: %w[Marco Giovanni],
                      last_name: %w[Some Thing],
                      age: [20, 22] }
        described_class.new(data: hash_data)
      end

      it 'takes the hash keys as headers' do
        expect(instance_from_hash.headers.sort).to eq(%i[first_name last_name age].sort)
      end

      it 'converts the Hash in an 2d Array like structure' do
        expect(instance_from_hash.rows).to eq(expected_rows)
      end
    end

    context 'when initializing using an Array of Arrays' do
      subject :instance_from_array_of_array do
        headers = %i[first_name last_name age]
        array_data = [['Marco', 'Some', 20], ['Giovanni', 'Thing', 22]]
        described_class.new(data: array_data, headers: headers)
      end

      it 'stores the data in the DataFrame' do
        expect(instance_from_array_of_array.rows).to eq(expected_rows)
      end
    end

    context 'when initializing using an Array of Hashes' do
      subject :instance_from_array_of_hash do
        headers = %i[first_name last_name age]
        array_data = [
          { first_name: 'Marco', last_name: 'Some', age: 20 },
          { first_name: 'Giovanni', last_name: 'Thing', age: 22 }
        ]
        described_class.new(data: array_data, headers: headers)
      end

      it 'stores the data in the DataFrame' do
        expect(instance_from_array_of_hash.rows).to eq(expected_rows)
      end
    end
  end

  context 'when accessing data stored in a DataFrame' do
    subject :data_frame do
      hash_data = { first_name: %w[Marco Giovanni Alice Marco],
                    last_name: %w[Some Thing Else Qwerty],
                    age: [20, 22, 24, 32] }
      described_class.new(data: hash_data)
    end

    context 'when accessing a column' do
      describe '#[]' do
        it 'returns a Series' do
          expect(data_frame[:first_name]).to be_a(TealToad::Series)
        end

        it 'contains the data in the given column' do
          expect(data_frame[:first_name]).to eq(TealToad::Series[*%w[Marco Giovanni Alice Marco]])
        end

        it 'returns nil when the argument passed is not a column name' do
          expect(data_frame[:invalid]).to be_nil
        end
      end
    end

    context 'when accessing a list of columns' do
      describe '#[]' do
        let :expected_result do
          hash_data = { first_name: %w[Marco Giovanni Alice Marco],
                        age: [20, 22, 24, 32] }
          described_class.new(data: hash_data)
        end

        it 'returns a DataFrame' do
          expect(data_frame[%i[first_name age]]).to be_a(described_class)
        end

        it 'returns a DataFrame with only the specified columns' do
          expect(data_frame[%i[first_name age]].rows).to eq(expected_result.rows)
        end

        it 'ignores invalid column names' do
          expect(data_frame[%i[first_name invalid age]].rows).to eq(expected_result.rows)
        end
      end
    end

    context 'when accesing a row' do
      describe '#[]' do
        let :expected_result_neg do
          described_class.new(data: { first_name: ['Alice'], last_name: ['Else'], age: [24] })
        end
        let :expected_result_pos do
          described_class.new(data: { first_name: ['Marco'], last_name: ['Some'], age: [20] })
        end

        it 'returns a DataFrame' do
          expect(data_frame[0]).to be_a(described_class)
        end

        it 'returns the row at the given index with an hash like syntax' do
          expect(data_frame[0].rows).to eq(expected_result_pos.rows)
        end

        it 'returns the item starting from the end when the argument is negative' do
          expect(data_frame[-2].rows).to eq(expected_result_neg.rows)
        end

        it 'returns nil when the given index is outside the range' do
          expect(data_frame[50]).to be_nil
        end
      end
    end

    context 'when accessing a range of rows' do
      describe '#[]' do
        let :expected_result do
          hash_data = { first_name: %w[Giovanni Alice],
                        last_name: %w[Thing Else],
                        age: [22, 24] }
          described_class.new(data: hash_data)
        end

        it 'returns a DataFrame' do
          expect(data_frame[1..2]).to be_a(described_class)
        end

        it 'returns a DataFrame containing the rows in the given range' do
          expect(data_frame[1..2].rows).to eq(expected_result.rows)
        end
      end
    end

    context 'when accessing a list of rows' do
      describe '#[]' do
        let :expected_result do
          hash_data = { first_name: %w[Giovanni Marco],
                        last_name: %w[Thing Qwerty],
                        age: [22, 32] }
          described_class.new(data: hash_data)
        end

        it 'returns a DataFrame' do
          expect(data_frame[[1, 3]]).to be_a(described_class)
        end

        it 'returns a DataFrame containing the rows a the given indexes' do
          expect(data_frame[[1, 3]].rows).to eq(expected_result.rows)
        end

        it 'ignores indexes out of range' do
          expect(data_frame[[1, 3, 8]].rows).to eq(expected_result.rows)
        end
      end
    end
  end
end
