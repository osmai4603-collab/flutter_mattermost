# PostInfo

Original OpenAPI schema: `PostInfo`

Additional team and channel context metadata for a post.

## Fields

- `channel_id`: string
  - The ID of the channel containing the post.
- `channel_type`: string
  - The type of the channel containing the post.
- `channel_display_name`: string
  - The display name of the channel containing the post.
- `has_joined_channel`: boolean
  - Whether the requesting user is already a member of the channel.
- `team_id`: string
  - The ID of the team containing the channel, if applicable.
- `team_type`: string
  - The type of the team containing the channel, if applicable.
- `team_display_name`: string
  - The display name of the team containing the channel, if applicable.
- `has_joined_team`: boolean
  - Whether the requesting user is already a member of the team.

## Example JSON

```json
{"channel_id": ""string"", "channel_type": ""string"", "channel_display_name": ""string"", "has_joined_channel": False, "team_id": ""string"", "team_type": ""string"", "team_display_name": ""string"", "has_joined_team": False}
```

