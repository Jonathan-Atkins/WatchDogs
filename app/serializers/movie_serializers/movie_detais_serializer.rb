class MovieDetailSerializer
  include JSONAPI::Serializer

  set_type :movie
  attributes :title, :release_year, :vote_average, :runtime, :genres, :summary

  attribute :cast do |movie|
    movie[:cast].first(10).map do |actor|
      {
        character: actor[:character],
        actor: actor[:actor]
      }
    end
  end

  attribute :total_reviews do |movie|
    movie[:reviews].count
  end

  attribute :reviews do |movie|
    movie[:reviews].first(5).map do |review|
      {
        author: review[:author],
        review: review[:review]
      }
    end
  end
end