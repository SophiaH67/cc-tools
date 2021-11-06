--[[ This file should be the first import,
many of my programs depend on functions in this file]]--

function table.filter(t, filterIter)
  local out = {}

  for k, v in pairs(t) do
    if filterIter(v, k, t) then out[k] = v end
  end

  return out
end

function table.rfilter(t, filterIter)
  local out = {}

  for k, v in pairs(t) do
    if type(v) == "table" then
      out[k] = table.rfilter(v, filterIter)
    else
      if filterIter(v, k, t) then out[k] = v end
    end
  end
  return out
end

function table.clone(orig, copies)
  local copies = copies or {}
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
    if copies[orig] then
      copy = copies[orig]
    else
      copy = {}
      copies[orig] = copy
      for orig_key, orig_value in next, orig, nil do
        copy[table.clone(orig_key, copies)] = table.clone(orig_value, copies)
      end
      setmetatable(copy, table.clone(getmetatable(orig), copies))
    end
  else -- number, string, boolean, etc
    copy = orig
  end
  return copy
end

function table.has_value (tab, val)
  for index, value in ipairs(tab) do
      if value == val then
          return true
      end
  end

  return false
end

-- A function that returns the facing direction between 2 points
function getDirection(x1, y1, z1, x2, y2, z2)
  local xDiff = x2 - x1
  local yDiff = y2 - y1
  local zDiff = z2 - z1
  if xDiff == 0 and yDiff == 0 and zDiff == 0 then
    return "SELF"
  elseif xDiff == 0 and yDiff == 0 then
    if zDiff > 0 then
      return "NORTH"
    else
      return "SOUTH"
    end
  elseif xDiff == 0 and zDiff == 0 then
    if yDiff > 0 then
      return "UP"
    else
      return "DOWN"
    end
  elseif yDiff == 0 and zDiff == 0 then
    if xDiff > 0 then
      return "EAST"
    else
      return "WEST"
    end
  else
    local angle = math.atan2(yDiff, xDiff)
    if angle < 0 then
      angle = angle + 2 * math.pi
    end
    if angle < math.pi / 4 then
      return "EAST"
    elseif angle < math.pi / 2 then
      return "SOUTH"
    elseif angle < 3 * math.pi / 4 then
      return "WEST"
    else
      return "NORTH"
    end
  end
end