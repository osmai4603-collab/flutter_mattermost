# AccessControlPolicy

Original OpenAPI schema: `AccessControlPolicy`

No description available in the official OpenAPI schema.

## Fields

- `id`: string
  - The unique identifier of the policy.
- `name`: string
  - The unique name for the policy.
- `display_name`: string
  - The human-readable name for the policy.
- `description`: string
  - A description of the policy.
- `expression`: string
  - The CEL expression defining the policy rules.
- `is_active`: boolean
  - Whether the policy is currently active and enforced.
- `create_at`: integer
  - The time in milliseconds the policy was created.
- `update_at`: integer
  - The time in milliseconds the policy was last updated.
- `delete_at`: integer
  - The time in milliseconds the policy was deleted.

## Example JSON

```json
{"id": ""string"", "name": ""string"", "display_name": ""string"", "description": ""string"", "expression": ""string"", "is_active": False, "create_at": 0, "update_at": 0, "delete_at": 0}
```
