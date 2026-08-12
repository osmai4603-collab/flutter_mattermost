# PropertyField

Original OpenAPI schema: `PropertyField`

No description available in the official OpenAPI schema.

## Fields

- `id`: string
  - A unique, 26 characters long, alphanumeric identifier for the property field.
- `type`: string
  - The type of the property field.
- `name`: string
  - The name of the property field.
- `description`: string
  - The description of the property field.
- `create_at`: integer
  - The property field creation timestamp, formatted as the number of milliseconds since the Unix epoch.
- `update_at`: integer
  - The property field update timestamp, formatted as the number of milliseconds since the Unix epoch.
- `delete_at`: integer
  - The property field deletion timestamp, formatted as the number of milliseconds since the Unix epoch. It equals 0 if not deleted.
- `attrs`: object
  - Additional attributes for the property field (options for select fields, visibility, etc.).

## Example JSON

```json
{"id": ""string"", "type": ""string"", "name": ""string"", "description": ""string"", "create_at": 0, "update_at": 0, "delete_at": 0, "attrs": {}}
```

