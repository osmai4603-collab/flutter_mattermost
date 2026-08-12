# GroupsAssociatedToChannels

Original OpenAPI schema: `GroupsAssociatedToChannels`

Source: https://developers.mattermost.com/api-documentation/#/schemas/GroupsAssociatedToChannels

a map of channel id(s) to the set of groups that constrain the corresponding channel in a team

## Fields

- `[key]`: array<GroupWithSchemeAdmin>

## Example JSON

```json
{
  "key": [
    {
      "group": {
        "id": "string",
        "name": "string",
        "display_name": "string",
        "description": "string",
        "source": "string",
        "remote_id": "string",
        "create_at": 0,
        "update_at": 0,
        "delete_at": 0,
        "has_syncables": false
      },
      "scheme_admin": false
    }
  ]
}
```
