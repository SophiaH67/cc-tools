local function addToPath(entry)
  if not fs.exists(entry) then return end
  shell.setPath(shell.path()..":"..entry)
end

addToPath("/bin")
addToPath("/bin/fredio")
addToPath("/bin/frednet")