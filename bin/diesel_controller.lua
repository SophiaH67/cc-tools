local energyCore = peripheral.wrap("back")

local function getPercentFull()
  return energyCore.getEnergy() / energyCore.getEnergyCapacity() * 100
end

local function turnOnGenerator()
  logger.info("Turning on generator")
  redstone.setOutput("front", false)
end

local function turnOffGenerator()
  logger.info("Turning off generator")
  redstone.setOutput("front", true)
end

while true do
  if getPercentFull() < 50 then turnOnGenerator() end
  if getPercentFull() > 90 then turnOffGenerator() end
  os.sleep(5)
end