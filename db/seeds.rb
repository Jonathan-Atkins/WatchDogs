# db/seeds.rb

# Ensure that all previous records are cleared before seeding new data
ViewingPartyUser.destroy_all
ViewingParty.destroy_all
User.destroy_all

# Example: Creating users with unique usernames
User.create!(name: "Danny DeVito", username: "danny_de_v", password: "jerseyMikesRox7")
User.create!(name: "Dolly Parton", username: "dollyP", password: "Jolene123")
User.create!(name: "Lionel Messi", username: "futbol_geek", password: "test123")

# You can also create other records needed for your application, such as movies, genres, etc.
# Example for viewing parties (ensure these are created after users, if applicable)

viewing_party1 = ViewingParty.create!(name: "Movie Night", start_time: DateTime.now, end_time: DateTime.now + 4.hours, movie_id: 278, movie_title: "Inception", host_id: User.first.id)

# Create some invitees for the viewing party, assuming you have a relationship with ViewingPartyUser
ViewingPartyUser.create!(viewing_party_id: viewing_party1.id, user_id: User.second.id)
ViewingPartyUser.create!(viewing_party_id: viewing_party1.id, user_id: User.third.id)

# Ensure other data or objects are created as needed for your app
# Example:
# ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#   MovieGenre.find_or_create_by!(name: genre_name)
# end

puts "Seeding complete!"