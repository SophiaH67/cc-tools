dofile('/lib/promise.lua')

p1 = Promise.new(function(resolve, reject)
  print("Hello from promise 1")
  os.sleep(2)
  print("Bye from promise 1")
  resolve("Something")
end)

p2 = Promise.new(function(resolve, reject)
  print("Hello from promise 2")
  os.sleep(3)
  print("Bye from promise 2")
  resolve("Something")
end)

p1.after(function () print("p1 after") end)
p2.after(function () print("p2 after") end)