require 'rails_helper'

RSpec.describe Movie, type: :poro do
  describe 'Movie_poro' do
    it 'formats a movie object' do
      movie_data = {
        :adult=>false,
        :backdrop_path=>nil,
        :genre_ids=>[],
        :id=>1356991,
        :original_language=>"xx",
        :original_title=>"Lord",
        :overview=>
        "Moving and changing worlds. They start with eight images and merge, gradually diminishing. In the end, they intertwine and become one.",
        :popularity=>0.328,
        :poster_path=>"/nTUYqnPrTr1CccWjGMVTLdduYm.jpg",
        :release_date=>"2024-10-26",
        :title=>"Lord",
        :video=>false,
        :vote_average=>0.0,
        :vote_count=>0
      }
      movie = Movie.new(movie_data)

      expect(movie.id). to eq("1356991")
      expect(movie.title).to eq("Lord")
      expect(movie.vote_average).to eq 0.0
    end
  end
end