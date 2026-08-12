# Get a user by auth data

Original OpenAPI operationId: `GetUserByAuthData`
- Method: `GET`
- Path: `/api/v4/users/auth_data`
- Summary: Get a user by auth data
- Description: Get a user by their external auth data identifier. The `value` is matched against what is stored in `Users.AuthData`, which for most identity providers is the identifier as the provider issues it.

The exception is Active Directory `objectGUID`: under `auth_service: ldap` it is stored as the LDAP filter hex-escape form (e.g. `\61\14\e1\d1\c5\35\18\4a\b6\60\d6\78\50\fd\0d\5d`), and under `auth_service: saml` it is stored as the standard Base64 of the same bytes (e.g. `YRTh0cU1GEq2YNZ4UP0NXQ==`). Use the form matching the user's current `AuthService`.

##### Permissions
Must be a system admin.

- Tags: users

## Parameters
- `value` (query, required, string) - The user's AuthData as stored in `Users.AuthData`. Must be URL-encoded; in particular, Base64 `+` characters must be sent as `%2B` so they are not decoded as spaces.


## Request body
No request body.

## Responses
- `200`: User retrieval successful
  - `application/json` -> User
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
