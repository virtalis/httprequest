# HTTP Request library
This is an example implementation of a Visionary Render plugin which provides utility functions for making HTTP(s) GET and POST requests from Lua, and providing the response to a callback function.

Makes use of this JSON Lua library for encoding: https://github.com/rxi/json.lua

## Installation
To install the plugin, download this repository and use Settings -> Plugins -> Add Plugin to install it into Visionary Render.

If you are unable to directly import the .zip, you may need to extract the contents to `(documents dir)/Visionary Render <version>/plugins` and make sure the outer folder is called "httprequest".

## Usage
Once installed, this plugin adds a table to the global Lua state called `httprequest`, with `get` and `post` functions.

### GET

`httprequest.get(url, options, callback)`

Use this function to make a HTTP(s) GET request. Include the protocol in the URL.

Provide a callback with the function signature `function(status, response)`

Example

```lua
httprequest.get("https://httpbin.org/get", nil, function(status, response)
        print(response) 
    end)
```

Response value

```
{
  "args": {}, 
  "headers": {
    "Accept": "*/*", 
    "Accept-Encoding": "gzip, deflate", 
    "Accept-Language": "en-gb", 
    "Host": "httpbin.org", 
    "Ua-Cpu": "AMD64"
  }, 
  "url": "https://httpbin.org/get"
}
```

### POST

`httprequest.post(url, body, options, callback)`

Use this function to make a HTTP(s) POST request. Include the protocol in the URL.

Provide body data in either plaintext or Lua table form. If given a Lua table, the table is encoded to JSON and the `Content-Type` header is set to `application/json` automatically.

Provide a callback with the function signature `function(status, response)`

Example (plaintext)

```lua
httprequest.post("https://httpbin.org/post", "body-test", nil, function(status, response)
        print(response) 
    end)
```

Response value

```
{
  "args": {}, 
  "data": "body-test", 
  "files": {}, 
  "form": {}, 
  "headers": {
    "Accept": "*/*", 
    "Accept-Encoding": "gzip, deflate", 
    "Accept-Language": "en-gb", 
    "Cache-Control": "no-cache", 
    "Content-Length": "9", 
    "Host": "httpbin.org", 
    "Ua-Cpu": "AMD64"
  }, 
  "json": null, 
  "url": "https://httpbin.org/post"
}
```

Example (JSON)

```lua
httprequest.post("https://httpbin.org/post", { boddydata = 10 }, nil, function(status, response)
        print(response) 
    end)
```

Response value

```
{
  "args": {}, 
  "data": "{\"boddydata\":10}", 
  "files": {}, 
  "form": {}, 
  "headers": {
    "Accept": "*/*", 
    "Accept-Encoding": "gzip, deflate", 
    "Accept-Language": "en-gb", 
    "Cache-Control": "no-cache", 
    "Content-Length": "16", 
    "Content-Type": "application/json", 
    "Host": "httpbin.org", 
    "Ua-Cpu": "AMD64"
  }, 
  "json": {
    "boddydata": 10
  }, 
  "url": "https://httpbin.org/post"
}
```

### encodeBasicAuth

`httprequest.encodeBasicAuth(username, password)`

Utility function to base64 encode a username and password into a Basic authorization string (i.e. `Basic <some encoded string>`) for use with an Authorization header.


### Options

The options parameter can be used to specify additional headers.

```lua
httprequest.get("url", {
    headers = {
        Authorization = httprequest.encodeBasicAuth("user", "pass")
    }
}, function(status, response) print("Authorized response") end)
```

To use hyphenated header names you will need to use table access syntax:

```lua
local options = { headers = {} }
options.headers["Content-Type"] = "application/json"
httprequest.post("url", some_json, options, callback)
```


## License
MIT