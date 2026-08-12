# ChannelMemberWithTeamData

Original OpenAPI schema: `ChannelMemberWithTeamData`

Source: https://developers.mattermost.com/api-documentation/#/schemas/ChannelMemberWithTeamData

## Fields

- `channel_id`: string
- `user_id`: string
- `roles`: string
- `last_viewed_at`: integer
  - The time in milliseconds the channel was last viewed by the user
- `msg_count`: integer
- `mention_count`: integer
- `notify_props`: ChannelNotifyProps
- `last_update_at`: integer
  - The time in milliseconds the channel member was last updated
- `team_display_name`: string
  - The display name of the team to which this channel belongs.
- `team_name`: string
  - The name of the team to which this channel belongs.
- `team_update_at`: integer
  - The time at which the team to which this channel belongs was last updated.

## Example JSON

```json
{
  "channel_id": "string",
  "user_id": "string",
  "roles": "string",
  "last_viewed_at": 0,
  "msg_count": 0,
  "mention_count": 0,
  "notify_props": {
    "email": "string",
    "push": "string",
    "desktop": "string",
    "mark_unread": "string"
  },
  "last_update_at": 0,
  "team_display_name": "string",
  "team_name": "string",
  "team_update_at": 0
}
```
