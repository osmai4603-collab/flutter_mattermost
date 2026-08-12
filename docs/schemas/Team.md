# Team

Original OpenAPI schema: `Team`

No description available in the official OpenAPI schema.

## Fields

- `id`: string
- `create_at`: integer
  - The time in milliseconds a team was created
- `update_at`: integer
  - The time in milliseconds a team was last updated
- `delete_at`: integer
  - The time in milliseconds a team was deleted
- `display_name`: string
- `name`: string
- `description`: string
- `email`: string
- `type`: string
- `allowed_domains`: string
- `invite_id`: string
- `allow_open_invite`: boolean
- `policy_id`: string
  - The data retention policy to which this team has been assigned. If no such policy exists, or the caller does not have the `sysconsole_read_compliance_data_retention` permission, this field will be null.

## Example JSON

```json
{"id": ""string"", "create_at": 0, "update_at": 0, "delete_at": 0, "display_name": ""string"", "name": ""string"", "description": ""string"", "email": ""string"", "type": ""string"", "allowed_domains": ""string"", "invite_id": ""string"", "allow_open_invite": False, "policy_id": ""string""}
```

