Promise = {}

function Promise.isPromise(obj)
  if obj == nil then
    return false
  end
  return obj.after ~= nil
end

-- Pure magic written by copilot
function Promise.new(fn)
  local self = setmetatable({}, {__index = Promise})
  self.state = 'pending'
  self.value = nil
  self.handlers = {}
  self.resolved = false
  self.rejected = false
  self.resolve = function(value)
    if self.resolved or self.rejected then return end
    self.resolved = true
    self.value = value
    self.state = 'resolved'
    for _, handler in ipairs(self.handlers) do
      handler(value)
    end
  end
  self.reject = function(reason)
    if self.resolved or self.rejected then return end
    self.rejected = true
    self.value = reason
    self.state = 'rejected'
    for _, handler in ipairs(self.handlers) do
      handler(reason)
    end
  end
  self.after = function(onFulfilled, onRejected)
    local nextPromise = Promise.new()
    table.insert(self.handlers, function(value)
      if self.state == 'resolved' then
        if type(onFulfilled) == 'function' then
          local result = onFulfilled(value)
          if Promise.isPromise(result) then
            result:after(nextPromise.resolve, nextPromise.reject)
          else
            nextPromise.resolve(result)
          end
        else
          nextPromise.resolve(value)
        end
      elseif self.state == 'rejected' then
        if type(onRejected) == 'function' then
          local result = onRejected(value)
          if Promise.isPromise(result) then
            result:after(nextPromise.resolve, nextPromise.reject)
          else
            nextPromise.resolve(result)
          end
        else
          nextPromise.reject(value)
        end
      end
    end)
    return nextPromise
  end
  if type(fn) == 'function' then
    local loop = libfredio.get_event_loop()
    loop.task(libfredio.async(fn)(self.resolve, self.reject))
  else
    self.resolve(fn)
  end
  return self
end

function Promise.all(promises)
  local self = Promise.new()
  local values = {}
  local count = 0
  for _, promise in ipairs(promises) do
    if Promise.isPromise(promise) then
      promise:after(function(value)
        count = count + 1
        values[count] = value
        if count == #promises then
          self.resolve(values)
        end
      end, self.reject)
    else
      count = count + 1
      values[count] = promise
      if count == #promises then
        self.resolve(values)
      end
    end
  end
  return self
end