Fabricator(:video) do
  title { Faker::Lorem.words(2).join(' ') }
  description { Faker::Lorem.words(30).join(' ') }
  category { Fabricate(:category) }
end
