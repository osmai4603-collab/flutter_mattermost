# Bot

Original OpenAPI schema: `Bot`

A bot account

## Fields

- `user_id`: string
  - The user id of the associated user entry.
- `create_at`: integer
  - The time in milliseconds a bot was created
- `update_at`: integer
  - The time in milliseconds a bot was last updated
- `delete_at`: integer
  - The time in milliseconds a bot was deleted
- `username`: string
- `display_name`: string
- `description`: string
- `owner_id`: string
  - The user id of the user that currently owns this bot.

## Example JSON

```json
{"user_id": ""string"", "create_at": 0, "update_at": 0, "delete_at": 0, "username": ""string"", "display_name": ""string"", "description": ""string"", "owner_id": ""string""}
```
