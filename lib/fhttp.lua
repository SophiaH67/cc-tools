local client = libfrednet.RTPClient("1.0.1", 80)

fhttp = {}

function fhttp.init()
  local loop = libfredio.get_event_loop() 
  loop.task(libfrednet.connect())
end

function fhttp.get(url, headers)
  local res = client.get_resource("/get", {url=url, headers=headers})
  return res.status_code, res.body
end

function fhttp.post(url, headers, data)
  local res = client.get_resource("/post", {url=url, headers=headers, data=data})
  return res.status_code, res.body
end
