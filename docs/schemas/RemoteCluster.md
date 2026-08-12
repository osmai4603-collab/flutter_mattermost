# RemoteCluster

Original OpenAPI schema: `RemoteCluster`

No description available in the official OpenAPI schema.

## Fields

- `remote_id`: string
- `remote_team_id`: string
- `name`: string
- `display_name`: string
- `site_url`: string
  - URL of the remote cluster
- `default_team_id`: string
  - The team where channels from invites are created
- `create_at`: integer
  - Time in milliseconds that the remote cluster was created
- `delete_at`: integer
  - Time in milliseconds that the remote cluster record was deleted
- `last_ping_at`: integer
  - Time in milliseconds when the last ping to the remote cluster was run
- `token`: string
- `remote_token`: string
- `topics`: string
- `creator_id`: string
- `plugin_id`: string
- `options`: integer
  - A bitmask with a set of option flags

## Example JSON

```json
{"remote_id": ""string"", "remote_team_id": ""string"", "name": ""string"", "display_name": ""string"", "site_url": ""string"", "default_team_id": ""string"", "create_at": 0, "delete_at": 0, "last_ping_at": 0, "token": ""string"", "remote_token": ""string"", "topics": ""string"", "creator_id": ""string"", "plugin_id": ""string"", "options": 0}
```
