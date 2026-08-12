# Condition

Original OpenAPI schema: `Condition`

No description available in the official OpenAPI schema.

## Fields

- `id`: string
  - A unique, 26 characters long, alphanumeric identifier for the condition.
- `condition_expr`: ConditionExprV1 (required)
- `version`: integer (required)
  - Version number of the condition expression format. Currently only version 1 is supported.
- `playbook_id`: string
  - The identifier of the playbook this condition belongs to.
- `run_id`: string
  - If this is a run condition (read-only snapshot), the identifier of the run. Empty for playbook conditions.
- `create_at`: integer
  - The condition creation timestamp, formatted as the number of milliseconds since the Unix epoch.
- `update_at`: integer
  - The condition update timestamp, formatted as the number of milliseconds since the Unix epoch.

## Example JSON

```json
{"id": ""string"", "condition_expr": "ConditionExprV1", "version": 0, "playbook_id": ""string"", "run_id": ""string"", "create_at": 0, "update_at": 0}
```
