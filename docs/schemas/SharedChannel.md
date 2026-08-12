# SharedChannel

Original OpenAPI schema: `SharedChannel`

No description available in the official OpenAPI schema.

## Fields

- `id`: string
  - Channel id of the shared channel
- `team_id`: string
- `home`: boolean
  - Is this the home cluster for the shared channel
- `readonly`: boolean
  - Is this shared channel shared as read only
- `name`: string
  - Channel name as it is shared (may be different than original channel name)
- `display_name`: string
  - Channel display name as it appears locally
- `purpose`: string
- `header`: string
- `creator_id`: string
  - Id of the user that shared the channel
- `create_at`: integer
  - Time in milliseconds that the channel was shared
- `update_at`: integer
  - Time in milliseconds that the shared channel record was last updated
- `remote_id`: string
  - Id of the remote cluster where the shared channel is homed

## Example JSON

```json
{"id": ""string"", "team_id": ""string"", "home": False, "readonly": False, "name": ""string"", "display_name": ""string"", "purpose": ""string"", "header": ""string"", "creator_id": ""string"", "create_at": 0, "update_at": 0, "remote_id": ""string""}
```
