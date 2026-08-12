# DataRetentionPolicyWithTeamAndChannelIds

Original OpenAPI schema: `DataRetentionPolicyWithTeamAndChannelIds`

Source: https://developers.mattermost.com/api-documentation/#/schemas/DataRetentionPolicyWithTeamAndChannelIds

## Fields

- `display_name`: string
  - The display name for this retention policy.
- `post_duration`: integer
  - The number of days a message will be retained before being deleted by this policy. If this value is less than 0, the policy has infinite retention (i.e. messages are never deleted).

- `team_ids`: array<string>
  - The IDs of the teams to which this policy should be applied.
- `channel_ids`: array<string>
  - The IDs of the channels to which this policy should be applied.

## Example JSON

```json
{
  "display_name": "string",
  "post_duration": 0,
  "team_ids": [
    "string"
  ],
  "channel_ids": [
    "string"
  ]
}
```
