# User

Original OpenAPI schema: `User`

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
- `first_name`: string
- `last_name`: string
- `nickname`: string
- `email`: string
- `email_verified`: boolean
- `auth_service`: string
- `roles`: string
- `locale`: string
- `notify_props`: UserNotifyProps
- `props`: object
- `last_password_update`: integer
- `last_picture_update`: integer
- `failed_attempts`: integer
- `mfa_active`: boolean
- `timezone`: Timezone
- `terms_of_service_id`: string
  - ID of accepted terms of service, if any. This field is not present if empty.
- `terms_of_service_create_at`: integer
  - The time in milliseconds the user accepted the terms of service

## Example JSON

```json
{"id": ""string"", "create_at": 0, "update_at": 0, "delete_at": 0, "username": ""string"", "first_name": ""string"", "last_name": ""string"", "nickname": ""string"", "email": ""string"", "email_verified": False, "auth_service": ""string"", "roles": ""string"", "locale": ""string"", "notify_props": "UserNotifyProps", "props": {}, "last_password_update": 0, "last_picture_update": 0, "failed_attempts": 0, "mfa_active": False, "timezone": "Timezone", "terms_of_service_id": ""string"", "terms_of_service_create_at": 0}
```

