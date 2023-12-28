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
end
