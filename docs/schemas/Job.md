# Job

Original OpenAPI schema: `Job`

No description available in the official OpenAPI schema.

## Fields

- `id`: string
  - The unique id of the job
- `type`: string
  - The type of job
- `create_at`: integer
  - The time at which the job was created
- `start_at`: integer
  - The time at which the job was started
- `last_activity_at`: integer
  - The last time at which the job had activity
- `status`: string
  - The status of the job
- `progress`: integer
  - The progress (as a percentage) of the job
- `data`: object
  - A freeform data field containing additional information about the job

## Example JSON

```json
{"id": ""string"", "type": ""string"", "create_at": 0, "start_at": 0, "last_activity_at": 0, "status": ""string"", "progress": 0, "data": {}}
```

