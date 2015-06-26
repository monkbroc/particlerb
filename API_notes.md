# Observations about the Particle cloud API

Inconsistent error messages:
  - 403 Forbidden for wrong device name or id: `{ "error": "...", "info": "..." }`
  - 400 BadRequest for function call when device is offline: `{ "ok": false, "error": "Timed out" }`
  - 408 TimedOut for get variable when device is offline: `{ "error": "Timed out." }`
  - 200 OK (!!!) when signaling when device is offline: `{ "ok": false, "errors": [ { "error": "Timed out, didn't hear back from device service" } ] }`
  - 404 NotFound when claiming and device doesn't exist: `{ "ok": false, "errors": ["device doesn't exist"] }`
  - 404 NotFound when claiming and device is offline: `{ "ok": false, "errors": [ [ "Core isn't online", 404 ] ] }`

    POST /v1/devices without id
    {
      "ok": false,
      "errors": [
        "arg.deviceID is empty"
      ]
    }
    
    GET /v1/devices/bad_variable
    {
      "ok": false,
      "error": "Variable not found"
    }

Rename device, function call, variable get don't return `{ ok: true }`

Function call when the device is offline return 400 Bad Request instead
of 408 Timed Out

Docs say: 
  - 400 Bad Request - [...] the requested subresource (variable/function) has not been exposed.
  - But when calling a wrong function name, the error is 404 Not Found


Variable get JSON contains `{ :cmd=>"VarReturn" }` as well as the whole `coreInfo` struct.

