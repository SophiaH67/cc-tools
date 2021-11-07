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
    os.queueEvent('promise_resolve', tostring(self))
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
  return Promise.new(function(resolve, reject)
    local results = {}
    local done = 0
    for i, promise in ipairs(promises) do
      promise.after(function (res)
        results[i] = res
        done = done + 1
        if done == #promises then
          resolve(results)
        end
      end, function (err) reject(err) end)
    end
  end)
end

function Promise.await(promise)
  local e, v = os.pullEvent('promise_resolve')
  while v ~= tostring(promise) do
    e, v = os.pullEvent('promise_resolve')
  end
  return promise.value
end