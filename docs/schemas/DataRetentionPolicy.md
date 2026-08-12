# DataRetentionPolicy

Original OpenAPI schema: `DataRetentionPolicy`

Source: https://developers.mattermost.com/api-documentation/#/schemas/DataRetentionPolicy

## Fields

- `display_name`: string
  - The display name for this retention policy.
- `post_duration`: integer
  - The number of days a message will be retained before being deleted by this policy. If this value is less than 0, the policy has infinite retention (i.e. messages are never deleted).

- `id`: string
  - The ID of this retention policy.

## Example JSON

```json
{
  "display_name": "string",
  "post_duration": 0,
  "id": "string"
}
```
