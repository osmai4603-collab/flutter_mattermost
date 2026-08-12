# OAuthApp

Original OpenAPI schema: `OAuthApp`

No description available in the official OpenAPI schema.

## Fields

- `id`: string
  - The client id of the application
- `client_secret`: string
  - The client secret of the application
- `name`: string
  - The name of the client application
- `description`: string
  - A short description of the application
- `icon_url`: string
  - A URL to an icon to display with the application
- `callback_urls`: array
  - A list of callback URLs for the appliation
- `homepage`: string
  - A link to the website of the application
- `is_trusted`: boolean
  - Set this to `true` to skip asking users for permission
- `create_at`: integer
  - The time of registration for the application
- `update_at`: integer
  - The last time of update for the application

## Example JSON

```json
{"id": ""string"", "client_secret": ""string"", "name": ""string"", "description": ""string"", "icon_url": ""string"", "callback_urls": [], "homepage": ""string"", "is_trusted": False, "create_at": 0, "update_at": 0}
```

