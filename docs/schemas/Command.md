# Command

Original OpenAPI schema: `Command`

No description available in the official OpenAPI schema.

## Fields

- `id`: string
  - The ID of the slash command
- `token`: string
  - The token which is used to verify the source of the payload
- `create_at`: integer
  - The time in milliseconds the command was created
- `update_at`: integer
  - The time in milliseconds the command was last updated
- `delete_at`: integer
  - The time in milliseconds the command was deleted, 0 if never deleted
- `creator_id`: string
  - The user id for the commands creator
- `team_id`: string
  - The team id for which this command is configured
- `trigger`: string
  - The string that triggers this command
- `method`: string
  - Is the trigger done with HTTP Get ('G') or HTTP Post ('P')
- `username`: string
  - What is the username for the response post
- `icon_url`: string
  - The url to find the icon for this users avatar
- `auto_complete`: boolean
  - Use auto complete for this command
- `auto_complete_desc`: string
  - The description for this command shown when selecting the command
- `auto_complete_hint`: string
  - The hint for this command
- `display_name`: string
  - Display name for the command
- `description`: string
  - Description for this command
- `url`: string
  - The URL that is triggered

## Example JSON

```json
{"id": ""string"", "token": ""string"", "create_at": 0, "update_at": 0, "delete_at": 0, "creator_id": ""string"", "team_id": ""string"", "trigger": ""string"", "method": ""string"", "username": ""string"", "icon_url": ""string"", "auto_complete": False, "auto_complete_desc": ""string"", "auto_complete_hint": ""string"", "display_name": ""string"", "description": ""string"", "url": ""string""}
```

