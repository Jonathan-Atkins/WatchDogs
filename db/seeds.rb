require 'date'

# Ensure that all previous records are cleared before seeding new data
ViewingPartyUser.destroy_all
ViewingParty.destroy_all
User.destroy_all

# Create example users
user1 = User.create!(name: "Danny DeVito", username: "danny_de_v", password: "jerseyMikesRox7")
user2 = User.create!(name: "Dolly Parton", username: "dollyP", password: "Jolene123")
user3 = User.create!(name: "Lionel Messi", username: "futbol_geek", password: "test123")

# Create 3 Viewing Parties with valid movies
viewing_party1 = ViewingParty.create!(
  name: "Classic Movie Night",
  start_time: DateTime.now + 1.day,
  end_time: DateTime.now + 1.day + 4.hours,
  movie_id: 278,
  movie_title: "The Shawshank Redemption",
  host_id: user1.id
)

viewing_party2 = ViewingParty.create!(
  name: "Mafia Movie Marathon",
  start_time: DateTime.now + 2.days,
  end_time: DateTime.now + 2.days + 4.hours,
  movie_id: 238,
  movie_title: "The Godfather",
  host_id: user2.id
)

viewing_party3 = ViewingParty.create!(
  name: "Sunday Chill Session",
  start_time: DateTime.now + 3.days,
  end_time: DateTime.now + 3.days + 4.hours,
  movie_id: 278,
  movie_title: "The Shawshank Redemption",
  host_id: user3.id
)

# Add invitees
[viewing_party1, viewing_party2, viewing_party3].each do |party|
  ViewingPartyUser.create!(viewing_party_id: party.id, user_id: user1.id) unless party.host_id == user1.id
  ViewingPartyUser.create!(viewing_party_id: party.id, user_id: user2.id) unless party.host_id == user2.id
  ViewingPartyUser.create!(viewing_party_id: party.id, user_id: user3.id) unless party.host_id == user3.id
end

puts "Seeding complete!"