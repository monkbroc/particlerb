# Observations about the Particle cloud API

Rename device, function call, variable get don't return `{ ok: true }`

Function call when the device is offline return 400 Bad Request instead
of 408 Timed Out

Sometimes API returns `{ "ok": false, "errors": [...] }` and sometimes `{ "ok": false, "error": "..." }`

Example:

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


Docs say: 
  - 400 Bad Request - [...] the requested subresource (variable/function) has not been exposed.
  - But when calling a wrong function name, the error is 404 Not Found


Variable get JSON contains `{ :cmd=>"VarReturn" }` as well as the whole `coreInfo` struct.

When device is offline, turning on the signal (rainbow mode) returns a
200 OK status with `{:ok=>false, :errors=>[{:error=>"Timed out, didn't
hear back from device service"}]}`
