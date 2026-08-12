# UserAthData

Original OpenAPI schema: `UserAuthData`

No description available in the official OpenAPI schema.

## Fields

- `auth_data`: string
  - Service-specific authentication data. Required and must be non-empty for external authentication services. Omit this field when `auth_service` is `email`.
- `auth_service`: string (required)
  - The authentication service such as "email", "gitlab", or "ldap". Use "email" with omitted `auth_data` to clear external authentication.

## Example JSON

```json
{"auth_data": ""string"", "auth_service": ""string""}
```

