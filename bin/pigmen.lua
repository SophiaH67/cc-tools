turtle.faceEast()
while true do
  if redstone.getInput("back") then
    turtle.attack()
    os.sleep(1)
  else
    os.sleep(1)
  end
end