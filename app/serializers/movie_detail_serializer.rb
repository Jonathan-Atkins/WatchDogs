class MovieDetailSerializer
  include JSONAPI::Serializer

  set_type :movie
  attributes :id, :title, :release_year, :vote_average, :runtime, :genres, :summary

  attribute :cast do |movie|
    movie.cast.first(10).map do |actor|
      {
        character: actor[:character],
        actor: actor[:actor]
      }
    end
  end
end