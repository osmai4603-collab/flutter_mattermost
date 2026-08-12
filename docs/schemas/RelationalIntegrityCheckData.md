# RelationalIntegrityCheckData

Original OpenAPI schema: `RelationalIntegrityCheckData`

an object containing the results of a relational integrity check.

## Fields

- `parent_name`: string
  - the name of the parent relation (table).
- `child_name`: string
  - the name of the child relation (table).
- `parent_id_attr`: string
  - the name of the attribute (column) containing the parent id.
- `child_id_attr`: string
  - the name of the attribute (column) containing the child id.
- `records`: array
  - the list of orphaned records found.

## Example JSON

```json
{"parent_name": ""string"", "child_name": ""string"", "parent_id_attr": ""string"", "child_id_attr": ""string"", "records": []}
```
