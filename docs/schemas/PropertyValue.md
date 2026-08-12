# PropertyValue

Original OpenAPI schema: `PropertyValue`

No description available in the official OpenAPI schema.

## Fields

- `id`: string
  - A unique, 26 characters long, alphanumeric identifier for the property value.
- `field_id`: string
  - The identifier of the property field this value belongs to.
- `value`: string
  - The JSON-encoded value of the property.
- `create_at`: integer
  - The property value creation timestamp, formatted as the number of milliseconds since the Unix epoch.
- `update_at`: integer
  - The property value update timestamp, formatted as the number of milliseconds since the Unix epoch.
- `delete_at`: integer
  - The property value deletion timestamp, formatted as the number of milliseconds since the Unix epoch. It equals 0 if not deleted.

## Example JSON

```json
{"id": ""string"", "field_id": ""string"", "value": ""string"", "create_at": 0, "update_at": 0, "delete_at": 0}
```

