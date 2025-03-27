class MovieGateway 
  
  def self.get_top_rated
    movies = connect_to_gateway("/3/movie/top_rated")
    movies.map { |m| Movie.new(m) }
  end
  
  def self.search_movies(query)
    movies = connect_to_gateway("/3/search/movie", {query: query})
    movies.map { |m| Movie.new(m) }
  end


  private

  def self.connect_to_gateway(endpoint, params = {})
    response     = Faraday.new('https://api.themoviedb.org').get(endpoint) do |req|
      req.params = params
      req.params[:api_key] = ENV["TMDB_KEY"] || Rails.application.credentials.tmdb[:key]
    end
    parse_data(response)
  end
  
  def self.parse_data(response)
    JSON.parse(response.body, symbolize_names: true)[:results]
  end
end