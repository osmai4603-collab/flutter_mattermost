# Session

Original OpenAPI schema: `Session`

No description available in the official OpenAPI schema.

## Fields

- `create_at`: integer
  - The time in milliseconds a session was created
- `device_id`: string
- `voip_device_id`: string
  - VoIP push token. Same prefix shape as device_id.
- `expires_at`: integer
  - The time in milliseconds a session will expire
- `id`: string
- `is_oauth`: boolean
- `last_activity_at`: integer
  - The time in milliseconds of the last activity of a session
- `props`: object
- `roles`: string
- `team_members`: array
- `token`: string
- `user_id`: string

## Example JSON

```json
{"create_at": 0, "device_id": ""string"", "voip_device_id": ""string"", "expires_at": 0, "id": ""string"", "is_oauth": False, "last_activity_at": 0, "props": {}, "roles": ""string"", "team_members": [], "token": ""string"", "user_id": ""string""}
```

