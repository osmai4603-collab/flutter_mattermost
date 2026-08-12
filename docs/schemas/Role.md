# Role

Original OpenAPI schema: `Role`

No description available in the official OpenAPI schema.

## Fields

- `id`: string
  - The unique identifier of the role.
- `name`: string
  - The unique name of the role, used when assigning roles to users/groups in contexts.
- `display_name`: string
  - The human readable name for the role.
- `description`: string
  - A human readable description of the role.
- `permissions`: array
  - A list of the unique names of the permissions this role grants.
- `scheme_managed`: boolean
  - indicates if this role is managed by a scheme (true), or is a custom stand-alone role (false).

## Example JSON

```json
{"id": ""string"", "name": ""string"", "display_name": ""string"", "description": ""string"", "permissions": [], "scheme_managed": False}
```
