local base64 = require "base64"
local json = require "json"

-- define the plugin functions as local functions
local function name()
  return "HTTP Request"
end

local function version()
  return "1.0.0"
end

local function resume(co)
  local result, err = coroutine.resume(co)
  if not result then
    print(err)
  end
end

local function encodeBasicAuth(user, pass)
  return "Basic " .. base64.enc(user .. ":" .. pass)
end

local function coRequest(web, callback, body)
  local co
  co = coroutine.create(function()
    web:send(body)

    -- Yield until done, or time out after 10 seconds.
    local timeout = 10
    local startTime = __Time
    while web.readyState < 4 and __Time - startTime < timeout do
      __deferredCall(function() resume(co) end, 0)
      coroutine.yield()
    end

    callback(web.status, web.responseText)
  end)
  resume(co)
end

local function setupRequest(method, url, options)
  print(method .. " " .. url)
  local web = luacom.CreateObject("MSXML2.XMLHTTP")
  web:open(method, url, true)

  if options and options.headers then
    for k, v in pairs(options.headers) do
      web:setRequestHeader(k, v)
    end
  end

  return web
end

local function get(url, options, callback)
  local request = setupRequest("GET", url, options)
  coRequest(request, callback)
end

local function post(url, body, options, callback)
  if type(body) == "table" then
    if not options then
      options = {}
    end
    if not options.headers then
      options.headers = {}
    end
    options.headers["Content-Type"] = "application/json"
    body = json.encode(body)
  end

  local request = setupRequest("POST", url, options)
  coRequest(request, callback, body)
end

local function init()

end

local function cleanup()

end

-- export the functions to the Lua state
return {
  name = name,
  version = version,
  init = init,
  cleanup = cleanup,
  encodeBasicAuth = encodeBasicAuth,
  get = get,
  post = post
}
