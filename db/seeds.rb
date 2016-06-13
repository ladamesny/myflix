# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
puts "Creating categories..."
comedy = Category.create(name: "Comedy")
tvshows = Category.create(name: "TV Shows")
documentaries = Category.create(name: "Documentaries")
romance = Category.create(name: "Romance")
action = Category.create(name: "Action")
thrillers = Category.create(name: "Thrillers")
user = User.create(email: "adames.larry@gmail.com", full_name: "Larry Adames", username: 'ladamesny', password: "Panchita1")
puts "Creating videos"
Category.all.each do |category|
  future = Video.create(title: "Futurama", description: "Pizza boy Philip J. Fry awakens in the 31st century after 1,000 years of cryogenic preservation in this animated series. After he gets a job at an interplanetary delivery service, Fry embarks on ridiculous escapades to make sense of his predicament.", small_img: "futurama.jpg", large_img: "futurama.jpg")
  family = Video.create(title: "Family Guy", description: "Family Guy revolves around a less than normal family in a less than normal world. With absurd and often spontaneous events this show will keep you laughing from the it starts up until it ends. The family Consists of six members Peter the father, Lois the mother, Stewie the homicidal baby, Chris the son, meg the daughter and Brian the dog who is often the smartest out of all of them.", small_img: "family_guy.jpg", large_img: "family_guy.jpg")
  batman = Video.create(title: "Batman", description: "First Batman", small_img: "batman.jpg", large_img: "batman.jpg")
  batman_returns = Video.create(title: "Batman Returns", description: "Best Batman", small_img: "batman_returns.jpg", large_img: "batman_returns.jpg")
  batman_forever = Video.create(title: "Batman Forever", description: "Best Batman", small_img: "batman_forever.jpg", large_img: "batman_forever.jpg")
  batman_and_robin = Video.create(title: "Batman and Robin", description: "First Batman", small_img: "batman_and_robin.jpg", large_img: "batman_and_robin.jpg")
  batman_begins = Video.create(title: "Batman Begins", description: "First Batman", small_img: "batman_begins.jpg", large_img: "batman_begins.jpg")
  the_dark_knight = Video.create(title: "The Dark Knight", description: "Best Batman", small_img: "the_dark_knight.jpg", large_img: "the_dark_knight.jpg")
  the_dark_knight_rises = Video.create(title: "The Dark knight Rises", description: "First Batman", small_img: "the_dark_knight_rises.jpg", large_img: "the_dark_knight_rises.jpg")
  batman_v_superman = Video.create(title: "Batman v Superman", description: "Best Batman", small_img: "batman_v_superman.jpg", large_img: "batman_v_superman.jpg")
  puts "Assigning #{category.name} movies..."
  future.category = category
  family.category = category
  batman.category = category
  batman_returns.category = category
  batman_forever.category = category
  batman_begins.category = category
  batman_and_robin.category = category
  the_dark_knight.category = category
  the_dark_knight_rises.category = category
  batman_v_superman.category = category

  puts "Saving #{category.name} video assignments"
  future.save!
  family.save!
  batman.save!
  batman_returns.save!
  batman_forever.save!
  batman_and_robin.save!
  batman_begins.save!
  the_dark_knight.save!
  the_dark_knight_rises.save!
  batman_v_superman.save!

end
