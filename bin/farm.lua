-- pos1 should be higher in both x and z
-- while keeping the same y as pos2

if turtle.pos1 == nil then
  print("Pos1 is not defined. Please define it now")
  turtle.pos1 = {}
  io.write("X: ")
  turtle.pos1.x = tonumber(read())
  io.write("Y: ")
  turtle.pos1.y = tonumber(read())
  io.write("Z: ")
  turtle.pos1.z = tonumber(read())
  turtle.saveState()
end

if turtle.pos2 == nil then
  print("Pos2 is not defined. Please define it now")
  turtle.pos2 = {}
  io.write("X: ")
  turtle.pos2.x = tonumber(read())
  io.write("Y: ")
  turtle.pos2.y = tonumber(read())
  io.write("Z: ")
  turtle.pos2.z = tonumber(read())
  turtle.saveState()
end

local function isGrown(block)
  if block.name == "minecraft:pumpkin" then return true end
  if block.name == "immersiveengineering:hemp" then return true end
  if block.name == "minecraft:potatoes" then return block.state.age == 7 end
  return false
end

local function checkAndBreakDown()
  local success, block = turtle.inspectDown()
  if not success then return end
  if not isGrown(block) then return end
  turtle.digDown()
  if block.name == "minecraft:potatoes" then turtle.placeDown() end
  inventoryCheck()
end

function storeItemsInChestAndReturn()
  local previousX, previousY, previousZ = turtle.x, turtle.y, turtle.z
  local previousFacing = turtle.direction
  turtle.dumbPathfind(turtle.pos1.x, turtle.pos1.y, turtle.pos1.z)
  turtle.faceEast()
  for i = 16,1,-1 do
    turtle.select(i)
    turtle.drop()
  end
  turtle.dumbPathfind(previousX, previousY, previousZ)
  if previousFacing == "NORTH" then turtle.faceNorth()
  elseif previousFacing == "EAST" then turtle.faceEast()
  elseif previousFacing == "SOUTH" then turtle.faceSouth()
  elseif previousFacing == "WEST" then turtle.faceWest() end
end

function storeItemsInChest()
  turtle.dumbPathfind(turtle.pos1.x, turtle.pos1.y, turtle.pos1.z)
  turtle.faceEast()
  for i = 16,1,-1 do
    turtle.select(i)
    turtle.drop()
  end
end

function inventoryCheck()
  if turtle.isInventoryFull() then
    storeItemsInChestAndReturn()
  end
end

function harvestAll()
  -- Go to starting position
  local x_diff = turtle.pos1.x - turtle.pos2.x
  local z_diff = turtle.pos1.z - turtle.pos2.z
  print("Pathfinding to start...")
  turtle.dumbPathfind(turtle.pos1.x, turtle.pos1.y, turtle.pos1.z)
  print("At start. Starting farm")
  for x_offset=2, x_diff + (x_diff % 2)+2, 2 do
    for z_offset=0, z_diff do
      checkAndBreakDown()
      turtle.north()
    end
    turtle.west()
    for z_offset=0, z_diff do
      checkAndBreakDown()
      turtle.south()
    end
    turtle.dumbPathfind(turtle.pos1.x-x_offset, turtle.pos1.y, turtle.pos1.z)
  end
end

while true do
  harvestAll()
  storeItemsInChest()
end