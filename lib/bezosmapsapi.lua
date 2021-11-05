bezosmaps = {}

function bezosmaps.searchForItem(item_name)
  local url = env.bezosmaps_url .. "/item?name=" .. item_name
  local response = http.get(url)
  if response then
    local data = textutils.unserializeJSON(response.readAll())
    return data
  end
  return false
end