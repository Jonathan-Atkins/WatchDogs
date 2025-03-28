class Movie
  attr_reader :id, :title, :vote_average, :release_year, :runtime, :genres, :summary, :cast

  def initialize(data, detailed: false)
    @id = data[:id].to_s
    @title = data[:title]
    @vote_average = data[:vote_average]
    @release_year = data[:release_date]

    if detailed
      @runtime = data[:runtime]
      @genres = data[:genres]&.map { |g| g[:name] } || []
      @summary = data[:overview]
      @cast = ten_cast_members(data.dig(:cast, :cast) || [])
    end
  end

  def ten_cast_members(cast)
    cast.take(10).map { |p| { character: p[:character], actor: p[:name] } }
  end
end