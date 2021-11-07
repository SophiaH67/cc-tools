homeassistant = {}

function homeassistant.get_state(entity_id)
  local url = env.homeassistant_base .. "/api/states/" .. entity_id
  local response = fhttp.get(url, {
    ["Authorization"] = "Bearer " .. env.homeassistant_token
  })
  response.after(function() print("OK!") end, function() print("FAIL!") end)
  return nil
end

function homeassistant.turnOnLight(entity_id)
  local url = env.homeassistant_base .. "/api/services/light/turn_on"
  local response = fhttp.post(url, textutils.serialiseJSON({
    ["entity_id"] = entity_id
  }),{
    ["Authorization"] = "Bearer " .. env.homeassistant_token,
    ["Content-Type"] = "application/json",
    ["Accept"] = "application/json",
  })
  response.after(function() print("OK!") end, function() print("FAIL!") end)
  return nil
end

function homeassistant.turnOffLight(entity_id)
  local url = env.homeassistant_base .. "/api/services/light/turn_off"
  local response = fhttp.post(url, textutils.serialiseJSON({
    ["entity_id"] = entity_id
  }),{
    ["Authorization"] = "Bearer " .. env.homeassistant_token,
    ["Content-Type"] = "application/json",
    ["Accept"] = "application/json",
  })
  response.after(function() print("OK!") end, function() print("FAIL!") end)
  return nil
end