# UserReport

Original OpenAPI schema: `UserReport`

No description available in the official OpenAPI schema.

## Fields

- `id`: string
- `create_at`: integer
  - The time in milliseconds a user was created
- `update_at`: integer
  - The time in milliseconds a user was last updated
- `delete_at`: integer
  - The time in milliseconds a user was deleted
- `username`: string
- `auth_data`: string
- `auth_service`: string
- `email`: string
- `nickname`: string
- `first_name`: string
- `last_name`: string
- `position`: string
- `roles`: string
- `locale`: string
- `timezone`: Timezone
- `disable_welcome_email`: boolean
- `last_login`: integer
  - Last time the user was logged in
- `last_status_at`: integer
  - Last time the user's status was updated
- `last_post_date`: integer
  - Last time the user made a post within the given date range
- `days_active`: integer
  - Total number of days a user posted within the given date range
- `total_posts`: integer
  - Total number of posts made by a user within the given date range

## Example JSON

```json
{"id": ""string"", "create_at": 0, "update_at": 0, "delete_at": 0, "username": ""string"", "auth_data": ""string"", "auth_service": ""string"", "email": ""string"", "nickname": ""string"", "first_name": ""string"", "last_name": ""string"", "position": ""string"", "roles": ""string"", "locale": ""string"", "timezone": "Timezone", "disable_welcome_email": False, "last_login": 0, "last_status_at": 0, "last_post_date": 0, "days_active": 0, "total_posts": 0}
```
