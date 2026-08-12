# ChannelWithTeamData

Original OpenAPI schema: `ChannelWithTeamData`

Source: https://developers.mattermost.com/api-documentation/#/schemas/ChannelWithTeamData

## Fields

- `id`: string
- `create_at`: integer
  - The time in milliseconds a channel was created
- `update_at`: integer
  - The time in milliseconds a channel was last updated
- `delete_at`: integer
  - The time in milliseconds a channel was deleted
- `team_id`: string
- `type`: string
- `display_name`: string
- `name`: string
- `header`: string
- `purpose`: string
- `last_post_at`: integer
  - The time in milliseconds of the last post of a channel
- `total_msg_count`: integer
- `extra_update_at`: integer
  - Deprecated in Mattermost 5.0 release
- `creator_id`: string
- `team_display_name`: string
  - The display name of the team to which this channel belongs.
- `team_name`: string
  - The name of the team to which this channel belongs.
- `team_update_at`: integer
  - The time at which the team to which this channel belongs was last updated.
- `policy_id`: string
  - The data retention policy to which this team has been assigned. If no such policy exists, or the caller does not have the `sysconsole_read_compliance_data_retention` permission, this field will be null.

## Example JSON

```json
{
  "id": "string",
  "create_at": 0,
  "update_at": 0,
  "delete_at": 0,
  "team_id": "string",
  "type": "string",
  "display_name": "string",
  "name": "string",
  "header": "string",
  "purpose": "string",
  "last_post_at": 0,
  "total_msg_count": 0,
  "extra_update_at": 0,
  "creator_id": "string",
  "team_display_name": "string",
  "team_name": "string",
  "team_update_at": 0,
  "policy_id": "string"
}
```
