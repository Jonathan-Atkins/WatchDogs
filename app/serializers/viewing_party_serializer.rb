class ViewingPartySerializer
  include JSONAPI::Serializer

  attributes :name, :start_time, :end_time, :movie_id, :movie_title, :host_id
  has_many :invitees, serializer: UserSerializer

  attribute :invitees do |obj|
    obj.invitees.map do |user|
      {
        id: user.id,
        name: user.name,
        username: user.username
      }
    end
  end
end