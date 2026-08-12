# PropertyFieldPatch

Original OpenAPI schema: `PropertyFieldPatch`

No description available in the official OpenAPI schema.

## Fields

- `name`: string
- `type`: string
- `attrs`: object
- `linked_field_id`: string
  - Set to empty string to unlink a linked field. Cannot be set to a new value on an existing field; linking is only allowed at creation time.


## Example JSON

```json
{"name": ""string"", "type": ""string"", "attrs": {}, "linked_field_id": ""string""}
```

