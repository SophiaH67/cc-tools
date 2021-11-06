homeassistant = {}

function homeassistant.get_state(entity_id)
  local url = env.homeassistant_base .. "/api/states/" .. entity_id
  local response = http.get(url, {
    ["Authorization"] = "Bearer " .. env.homeassistant_token
  })
  if response then
    print(response.readAll())
    response.close()
  end
  return nil
end

function homeassistant.turnOnLight(entity_id)
  local url = env.homeassistant_base .. "/api/services/light/turn_on"
  local response = http.post(url, textutils.serialiseJSON({
    ["entity_id"] = entity_id
  }),{
    ["Authorization"] = "Bearer " .. env.homeassistant_token,
    ["Content-Type"] = "application/json",
    ["Accept"] = "application/json",
  })
  if response then
    print(response.readAll())
    response.close()
  end
  return nil
end

function homeassistant.turnOffLight(entity_id)
  local url = env.homeassistant_base .. "/api/services/light/turn_off"
  local response = http.post(url, textutils.serialiseJSON({
    ["entity_id"] = entity_id
  }),{
    ["Authorization"] = "Bearer " .. env.homeassistant_token,
    ["Content-Type"] = "application/json",
    ["Accept"] = "application/json",
  })
  if response then
    print(response.readAll())
    response.close()
  end
  return nil
end