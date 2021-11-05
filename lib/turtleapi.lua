if not turtle then return end

oturtle = table.clone(turtle)

-- #region [[ State handling functions ]]--
turtle._loaded = false

-- keys that are removed for serialization
local hidden_keys = {"_loaded", "native", "movementHooks"}

--[[ This is currently broken.
Function only gets triggered on initial assignment.
Not reassignment. If you figure out how to, please
send a message to computer 33 ]]--
setmetatable(turtle, {
  __newindex = function (t, k, v)
    rawset(turtle, k, v)
    if table.has_value(hidden_keys, k) then return end
    if turtle._loaded then turtle.saveState() end
  end
})

function turtle.saveState()
  -- this is just a replica of turtle but without functions
  local state = table.rfilter(turtle, function(v, k, t) return type(v) ~= 'function' end)
  state = table.filter(state, function(v, k, t) return not table.has_value(hidden_keys, k) end)
  if not fs.isDir('/var/') then fs.makeDir('/var/') end
  local state_file = fs.open('/var/state.txt', 'w')
  state_file.write(textutils.serialise(state))
  state_file.close()
end

function turtle.loadState()
  if not fs.isDir('/var/') then return false end
  if not fs.exists('/var/state.txt') then return false end
  local state_file = fs.open('/var/state.txt', 'r')
  state_file.close()
  state_file = fs.open('/var/state.txt', 'r')
  local state = textutils.unserialise(state_file.readAll())
  state_file.close()
  for k,v in pairs(state) do
    rawset(turtle,k,v)
  end
end
-- #endregion

-- #region [[ Basic directions ]]--
function turtle.turnLeft ()
  if turtle.direction == "NORTH" then turtle.direction = "WEST"; turtle.saveState()
  elseif turtle.direction == "WEST" then turtle.direction = "SOUTH"; turtle.saveState()
  elseif turtle.direction == "SOUTH" then turtle.direction = "EAST"; turtle.saveState()
  elseif turtle.direction == "EAST" then turtle.direction = "NORTH"; turtle.saveState() end
  oturtle.turnLeft()
end

function turtle.turnRight ()
  if turtle.direction == "NORTH" then turtle.direction = "EAST"; turtle.saveState()
  elseif turtle.direction == "EAST" then turtle.direction = "SOUTH"; turtle.saveState()
  elseif turtle.direction == "SOUTH" then turtle.direction = "WEST"; turtle.saveState()
  elseif turtle.direction == "WEST" then turtle.direction = "NORTH"; turtle.saveState() end
  oturtle.turnRight()
end

function turtle.faceNorth ()
  if turtle.direction == "EAST" then turtle.turnLeft() end
  if turtle.direction == "SOUTH" then
    turtle.turnLeft()
    turtle.turnLeft()
  end
  if turtle.direction == "WEST" then turtle.turnRight() end
end

function turtle.faceEast ()
  if turtle.direction == "NORTH" then turtle.turnRight()
  elseif turtle.direction == "SOUTH" then turtle.turnLeft()
  elseif turtle.direction == "WEST" then
    turtle.turnLeft()
    turtle.turnLeft()
  end
end

function turtle.faceSouth ()
  if turtle.direction == "NORTH" then 
    turtle.turnLeft()
    turtle.turnLeft()
  elseif turtle.direction == "EAST" then turtle.turnRight()
  elseif turtle.direction == "WEST" then turtle.turnLeft() end
end

function turtle.faceWest ()
  if turtle.direction == "NORTH" then turtle.turnLeft()
  elseif turtle.direction == "EAST" then
    turtle.turnLeft()
    turtle.turnLeft()
  elseif turtle.direction == "SOUTH" then turtle.turnRight() end
end
-- #endregion

-- #region [[ Movement Hooks ]]

turtle.movementHooks = {}

local function runMovementHooks()
  for _, hook in pairs(turtle.movementHooks) do
    hook()
  end
end

-- #endregion

-- #region [[ Basic Movement ]]--

function turtle.forward()
  local previousX = turtle.x
  local previousZ = turtle.z
  if turtle.direction == "NORTH" then turtle.z = turtle.z - 1
  elseif turtle.direction == "EAST" then turtle.x = turtle.x + 1
  elseif turtle.direction == "SOUTH" then turtle.z = turtle.z + 1
  elseif turtle.direction == "WEST" then turtle.x = turtle.x - 1 end
  turtle.saveState()
  local success, msg = oturtle.forward()
  if not success then
    turtle.x = previousX
    turtle.z = previousZ
    turtle.saveState()
  else runMovementHooks() end
  return success, msg
end

function turtle.back()
  local previousX = turtle.x
  local previousZ = turtle.z
  if turtle.direction == "NORTH" then turtle.z = turtle.z + 1
  elseif turtle.direction == "EAST" then turtle.x = turtle.x - 1
  elseif turtle.direction == "SOUTH" then turtle.z = turtle.z - 1
  elseif turtle.direction == "WEST" then turtle.x = turtle.x + 1 end
  turtle.saveState()
  local success, msg = oturtle.back()
  if not success then
    turtle.x = previousX
    turtle.z = previousZ
    turtle.saveState()
  else runMovementHooks() end
  return success, msg
end

function turtle.up()
  local previousY = turtle.y
  turtle.y = turtle.y + 1
  turtle.saveState()
  local success, msg = oturtle.up()
  if not success then
    turtle.y = previousY
    turtle.saveState()
  else runMovementHooks() end
  return success, msg
end

function turtle.down()
  local previousY = turtle.y
  turtle.y = turtle.y - 1
  turtle.saveState()
  local success, msg = oturtle.down()
  if not success then
    turtle.y = previousY
    turtle.saveState()
  else runMovementHooks() end
  return success, msg
end

-- #endregion

-- #region [[ Directional Movement ]]--

function turtle.north()
  turtle.faceNorth()
  return turtle.forward()
end

function turtle.east()
  turtle.faceEast()
  return turtle.forward()
end

function turtle.south()
  turtle.faceSouth()
  return turtle.forward()
end

function turtle.west()
  turtle.faceWest()
  return turtle.forward()
end

-- #endregion

-- #region [[ Dumb Pathfinding ]]

-- Assumes all blocks are air. Perfect for farms
function turtle.dumbPathfind(targetX, targetY, targetZ)
  while turtle.y ~= targetY do
    if turtle.y > targetY then
      while not turtle.down() do os.sleep(1) end
    else
      while not turtle.up() do os.sleep(1) end
    end
  end
  while turtle.x ~= targetX do
    if turtle.x > targetX then
      while not turtle.west() do os.sleep(1) end
    else
      while not turtle.east() do os.sleep(1) end
    end
  end

  while turtle.z ~= targetZ do
    if turtle.z > targetZ then
      while not turtle.north() do os.sleep(1) end
    else
      while not turtle.south() do os.sleep(1) end
    end
  end
end

-- #endregion

-- #region [[ Inspecting ]]

local function updateInventory(p, block)
  if p == nil then return end
  if p.size == nil then return end
  block.inventory = {
    maxCount=p.size(),
    items={}
  }
  for inventorySlot = 1, p.size() do
    local item = p.getItemDetail(inventorySlot)
    if item == nil then
      item = { name = "minecraft:air", displayName = "", count = 0, maxCount= 64}
    end
    item.slot = inventorySlot
    block.inventory.items[inventorySlot] = item
  end
end

function turtle.inspect()
  local success, block = oturtle.inspect()

  if not success then
    block = {name="minecraft:air"}
  end

  block.x = turtle.x
  block.y = turtle.y
  block.z = turtle.z

  if turtle.direction == "NORTH" then block.z = block.z - 1
  elseif turtle.direction == "SOUTH" then block.z = block.z + 1
  elseif turtle.direction == "EAST" then block.x = block.x + 1
  elseif turtle.direction == "WEST" then block.z = block.z - 1 end

  updateInventory(peripheral.wrap("front"), block)

  return success, block
end

function turtle.inspectUp()
  local success, block = oturtle.inspectUp()

  if not success then
    block = {name="minecraft:air"}
  end

  block.x = turtle.x
  block.y = turtle.y+1
  block.z = turtle.z

  updateInventory(peripheral.wrap("up"), block)

  return success, block
end

function turtle.inspectDown()
  local success, block = oturtle.inspectDown()

  if not success then
    block = {name="minecraft:air"}
  end

  block.x = turtle.x
  block.y = turtle.y-1
  block.z = turtle.z

  updateInventory(peripheral.wrap("down"), block)

  return success, block
end

-- #endregion

-- #region [[ BezosMaps integration ]]

function turtle.explore(max_moves)
  local moves = {turtle.north, turtle.east, turtle.south, turtle.west, turtle.up, turtle.down}
  max_moves = max_moves or math.huge
  for move_count = 1, max_moves do
    moves[math.random(1, #moves)]()
  end

end

function turtle.movementHooks.updateBlocks()
  local inspections = {
    {turtle.inspect()},
    {turtle.inspectUp()},
    {turtle.inspectDown()}
  }
  for _, inspection in pairs(inspections) do
    local success, block = inspection[1], inspection[2]
    if not success then
      block = {name="minecraft:air", x=block.x, y=block.y, z=block.z}
    end
    local url = env.bezosmaps_url .. "/block/" .. block.x .. "/" .. block.y .. "/" .. block.z
    http.post(url, textutils.serialiseJSON(block), {["Content-Type"]="application/json"})
  end
end

function turtle.isWalkable(x,y,z)
  local res = http.get(env.bezosmaps_url.."/block/"..x.."/"..y.."/"..z)
  if not res then return false end
  local body = textutils.unserialiseJSON(res.readAll())
  res.close()
  return body.walkable
end

-- #endregion

-- #region [[ Utils ]]

function turtle.isInventoryFull()
  for i = 1,16 do
    if turtle.getItemCount(i) == 0 then
      return false
    end
  end
  return true
end

-- #endregion

-- #region [[ Misc functions directions ]]--
function turtle.detectDirection()
  local previousX = turtle.x
  local previousZ = turtle.z
  if oturtle.forward() then
    local x,y,z = gps.locate()
    oturtle.back()
    if not x then return false end
    local xdiff = previousX - x
    local zdiff = previousZ - z
    if xdiff == -1 then return "EAST"
    elseif xdiff == 1 then return "WEST"
    elseif zdiff == -1 then return "SOUTH"
    elseif zdiff == 1 then return "NORTH" end
  elseif oturtle.back() then
    local x,y,z = gps.locate()
    oturtle.forward()
    if not x then return false end
    local xdiff = previousX - x
    local zdiff = previousZ - z
    if xdiff == -1 then return "WEST"
    elseif xdiff == 1 then return "EAST"
    elseif zdiff == -1 then return "NORTH"
    elseif zdiff == 1 then return "SOUTH" end
  end
end
-- #endregion

-- #region [[ Load previous state ]]--
turtle.loadState()
turtle._loaded = true

if not turtle.x then
  -- Position is not set
  local gpsX,gpsY,gpsZ = gps.locate()
  if gpsX then 
    turtle.x = gpsX
    turtle.y = gpsY
    turtle.z = gpsZ
  else
    print("Could not get position from GPS. Please supply current position")
    io.write("X: ")
    turtle.x = tonumber(read())
    io.write("Y: ")
    turtle.y = tonumber(read())
    io.write("Z: ")
    turtle.z = tonumber(read())
  end
end

if not turtle.direction then
  turtle.direction = turtle.detectDirection()
  if not turtle.direction then
    print("----------------------------------")
    print("Could not determine turtle direction. ")
    print("Please specify current facing direction.")
    print("NORTH, EAST, SOUTH, WEST: ")
    turtle.direction = read()
  end
  turtle.saveState()
end
-- #endregion