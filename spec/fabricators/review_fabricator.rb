Fabricator(:review) do
  user { Fabricate(:user) }
  video { Fabricate(:video) }
  body { Faker::Lorem.paragraphs(2).join(' ') }
  rating { Faker::Number.between(1,5) }
end
