# DataRetentionPolicyWithTeamAndChannelCounts

Original OpenAPI schema: `DataRetentionPolicyWithTeamAndChannelCounts`

Source: https://developers.mattermost.com/api-documentation/#/schemas/DataRetentionPolicyWithTeamAndChannelCounts

## Fields

- `display_name`: string
  - The display name for this retention policy.
- `post_duration`: integer
  - The number of days a message will be retained before being deleted by this policy. If this value is less than 0, the policy has infinite retention (i.e. messages are never deleted).

- `id`: string
  - The ID of this retention policy.
- `team_count`: integer
  - The number of teams to which this policy is applied.
- `channel_count`: integer
  - The number of channels to which this policy is applied.

## Example JSON

```json
{
  "display_name": "string",
  "post_duration": 0,
  "id": "string",
  "team_count": 0,
  "channel_count": 0
}
```
