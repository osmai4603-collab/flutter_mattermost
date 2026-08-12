# Scheme

Original OpenAPI schema: `Scheme`

No description available in the official OpenAPI schema.

## Fields

- `id`: string
  - The unique identifier of the scheme.
- `name`: string
  - The human readable name for the scheme.
- `description`: string
  - A human readable description of the scheme.
- `create_at`: integer
  - The time at which the scheme was created.
- `update_at`: integer
  - The time at which the scheme was last updated.
- `delete_at`: integer
  - The time at which the scheme was deleted.
- `scope`: string
  - The scope to which this scheme can be applied, either "team" or "channel".
- `default_team_admin_role`: string
  - The id of the default team admin role for this scheme.
- `default_team_user_role`: string
  - The id of the default team user role for this scheme.
- `default_channel_admin_role`: string
  - The id of the default channel admin role for this scheme.
- `default_channel_user_role`: string
  - The id of the default channel user role for this scheme.

## Example JSON

```json
{"id": ""string"", "name": ""string"", "description": ""string"", "create_at": 0, "update_at": 0, "delete_at": 0, "scope": ""string"", "default_team_admin_role": ""string"", "default_team_user_role": ""string"", "default_channel_admin_role": ""string"", "default_channel_user_role": ""string""}
```
