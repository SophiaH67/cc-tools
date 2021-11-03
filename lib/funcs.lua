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