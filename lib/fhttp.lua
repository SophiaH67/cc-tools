local client = libfrednet.RTPClient("1.0.1", 80)

fhttp = {}


function fhttp.init()
  local loop = libfredio.get_event_loop() 
  loop.task(libfrednet.connect())
end

function fhttp.get(url, headers)
  return Promise.new(function(resolve, reject)
    local res = client.get_resource("/get", {url=url, headers=headers})
    -- if res.status_code is between 200 and 400
    if res.status_code >= 200 and res.status_code < 400 then
      resolve(res)
    else
      reject(res)
    end
  end)
end

function fhttp.post(url, body, headers)
  return Promise.new(function(resolve, reject)
    local res = client.get_resource("/post", {url=url, headers=headers, body=body})
    -- if res.status_code is between 200 and 400
    if res.status_code >= 200 and res.status_code < 400 then
      resolve(res)
    else
      reject(res)
    end
  end)
end