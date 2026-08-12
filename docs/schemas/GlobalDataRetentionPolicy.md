# GlobalDataRetentionPolicy

Original OpenAPI schema: `GlobalDataRetentionPolicy`

No description available in the official OpenAPI schema.

## Fields

- `message_deletion_enabled`: boolean
  - Indicates whether data retention policy deletion of messages is enabled globally.
- `file_deletion_enabled`: boolean
  - Indicates whether data retention policy deletion of file attachments is enabled globally.
- `message_retention_cutoff`: integer
  - The current server timestamp before which messages should be deleted.
- `file_retention_cutoff`: integer
  - The current server timestamp before which files should be deleted.

## Example JSON

```json
{"message_deletion_enabled": False, "file_deletion_enabled": False, "message_retention_cutoff": 0, "file_retention_cutoff": 0}
```

