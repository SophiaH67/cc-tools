local farm_computers = {12, 41, 51, 54}

if table.has_value(farm_computers, os.getComputerID()) then
  shell.run("/bin/farm.lua")
end

if os.getComputerID() == 9 then
  shell.run("/bin/diesel_controller.lua")
end