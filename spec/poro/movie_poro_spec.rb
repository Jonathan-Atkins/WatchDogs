require 'rails_helper'

RSpec.describe Movie, type: :poro do
  describe 'Movie PORO' do
    let(:default_data) { { id: 1356991, title: "Lord", vote_average: 0.0 } }
    let(:missing_title) { { id: 123, vote_average: 8.5 } }
    let(:missing_vote) { { id: 456, title: "No Rating Movie" } }
    let(:missing_id) { { title: "Mystery Movie", vote_average: 7.2 } }
    let(:nil_values) { { id: nil, title: nil, vote_average: nil } }
    let(:unexpected_types) { { id: "789", title: 12345, vote_average: "9.9" } }
    let(:empty_input) { {} }

    subject { Movie.new(movie_data) }

    context 'when given valid data' do
      let(:movie_data) { default_data }

      it 'formats a movie object correctly' do
        expect(subject.id).to eq("1356991")
        expect(subject.title).to eq("Lord")
        expect(subject.vote_average).to eq(0.0)
      end
    end

    context 'when title is missing' do
      let(:movie_data) { missing_title }

      it 'handles missing title' do
        expect(subject.id).to eq("123")
        expect(subject.title).to be_nil
        expect(subject.vote_average).to eq(8.5)
      end
    end

    context 'when vote_average is missing' do
      let(:movie_data) { missing_vote }

      it 'handles missing vote_average' do
        expect(subject.id).to eq("456")
        expect(subject.title).to eq("No Rating Movie")
        expect(subject.vote_average).to be_nil 
      end
    end

    context 'when id is missing' do
      let(:movie_data) { missing_id }

      it 'handles missing id' do
        expect(subject.id).to eq("") 
        expect(subject.title).to eq("Mystery Movie")
        expect(subject.vote_average).to eq(7.2)
      end
    end

    context 'when all values are nil' do
      let(:movie_data) { nil_values }

      it 'handles nil values for attributes' do
        expect(subject.id).to eq("")
        expect(subject.title).to be_nil
        expect(subject.vote_average).to be_nil
      end
    end

    context 'when given unexpected data types' do
      let(:movie_data) { unexpected_types }

      it 'handles unexpected data types' do
        expect(subject.id).to eq("789")
        expect(subject.title).to eq(12345) 
        expect(subject.vote_average).to eq("9.9") 
      end
    end

    context 'when given an empty hash' do
      let(:movie_data) { empty_input }

      it 'handles empty input gracefully' do
        expect(subject.id).to eq("")
        expect(subject.title).to be_nil
        expect(subject.vote_average).to be_nil
      end
    end
  end
end