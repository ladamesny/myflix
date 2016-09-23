Fabricator(:queue_item) do
  user     { Fabricate(:user) }
  video    { Fabricate(:video) }
  position { Fabricate.sequence }
end
