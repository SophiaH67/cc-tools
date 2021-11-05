local item_name = arg[1]

if item_name == nil then
  print("Usage: search <item name>")
  return
end

local results = bezosmaps.searchForItem(item_name)

local x,y,z = gps.locate()

if not x then
  print("Could not find your location.")
  return
end


table.sort(results, function(a, b)
  return math.sqrt(math.pow(a.inventory.block.x - x, 2) + math.pow(a.inventory.block.y - y, 2) + math.pow(a.inventory.block.z - z, 2)) < math.sqrt(math.pow(b.inventory.block.x - x, 2) + math.pow(b.inventory.block.y - y, 2) + math.pow(b.inventory.block.z - z, 2))
end)

print(type(results))

for _, result in ipairs(results) do
  print(result.name .. " (" .. result.count .. "/" .. result.max_count .. ") " .. result.inventory.block.x .. "," .. result.inventory.block.y .. "," .. result.inventory.block.z)
end