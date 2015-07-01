# Observations about the Particle cloud API

Discussion points:

  - How to set name of token
  - Mismatch between limit to publish (max every second) and webhook (max every 6 seconds)
  - What is product_id? Is it related to the hardware or firmware? Related to teams?
  - Which platform_id are for public use? 0 for Core, 6 for Photon, 8 for P1.

Inconsistent error messages:

  - 403 Forbidden for wrong device name or id: `{ "error": "...", "info": "..." }`
  - 400 BadRequest for function call when device is offline: `{ "ok": false, "error": "Timed out" }`
  - 408 TimedOut for get variable when device is offline: `{ "error": "Timed out." }`
  - 200 OK (!) when signaling when device is offline: `{ "ok": false, "errors": [ { "error": "Timed out, didn't hear back from device service" } ] }`
  - 404 NotFound when claiming and device doesn't exist: `{ "ok": false, "errors": ["device doesn't exist"] }`
  - 404 NotFound when claiming and device is offline: `{ "ok": false, "errors": [ [ "Core isn't online", 404 ] ] }`
  - 200 OK when flashing and device is offline `{ "ok": false, "errors": [ "Request Timed Out" ] }`

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

Webhook test message doesn't use authentication settings (sent when doing a GET to a webhook url)

Webhook:

{
  "webook": {
    "id": "558d5710fc98c66474dfac1a",
    "url": "http://m3.munirent.co:8888/",
    "deviceID": null,
    "event": "68c57e6752d5e0a5",
    "created_at": "2015-06-26T13:43:44.116Z",
    "mydevices": null,
    "requestType": null,
    "headers": null,
    "json": null,
    "query": null,
    "auth": {
      "username": "test",
      "password": "test2"
    }
  },
  "error": "Error: socket hang up"
}

HTTP request for test message:
$ nc -l -p 8888
POST / HTTP/1.1
host: m3.munirent.co:8888
content-type: application/x-www-form-urlencoded
accept: application/json
content-length: 42
Connection: keep-alive

event=68c57e6752d5e0a5&data=Test%20Message


When there are too many hooks, the response is 200 OK with {"ok": false, "error": "Too many web hooks for this device"}. It should be 400 Bad Request

Device "last_app" only shows up in the /v1/devices endpoint, not the /v1/devices/{id} endpoint

No error when deleting a non-existent token? 200 OK with { "ok": true }

Output of flash with compile errors is weirdly nested:
{ "ok": false, "errors": [ { "ok": false, errors: [ "compiler errors\netc...", { "killed": false, ... } ] } ] }


When flashing a binary, the response is 200 OK with `{"id": "__PARTICLE_DEVICE_ID__", "status:: "Update started"}` but missing "ok": true. Also other endpoints don't return the id like this.


