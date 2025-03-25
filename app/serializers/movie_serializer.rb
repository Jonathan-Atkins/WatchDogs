class MovieSerializer
  include JSONAPI::Serializer 
  attributes :id, :title, :vote_average
end