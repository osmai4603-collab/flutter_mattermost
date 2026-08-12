# RecapChannel

Original OpenAPI schema: `RecapChannel`

No description available in the official OpenAPI schema.

## Fields

- `id`: string
  - Unique identifier for the recap channel
- `recap_id`: string
  - ID of the parent recap
- `channel_id`: string
  - ID of the channel that was summarized
- `channel_name`: string
  - Display name of the channel
- `highlights`: array
  - Key discussion points and important information from the channel
- `action_items`: array
  - Tasks, todos, and action items mentioned in the channel
- `source_post_ids`: array
  - IDs of the posts used to generate this summary
- `create_at`: integer
  - The time in milliseconds the recap channel was created

## Example JSON

```json
{"id": ""string"", "recap_id": ""string"", "channel_id": ""string"", "channel_name": ""string"", "highlights": [], "action_items": [], "source_post_ids": [], "create_at": 0}
```
