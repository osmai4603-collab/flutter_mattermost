# Create a user

Original OpenAPI operationId: `CreateUser`
- Method: `POST`
- Path: `/api/v4/users`
- Summary: Create a user
- Description: Create a new user on the system. Password is required for email login. For other authentication types such as LDAP or SAML, auth_data and auth_service fields are required.
##### Permissions
No permission required for creating email/username accounts on an open server. Auth Token is required for other authentication types such as LDAP or SAML.

- Tags: users

## Parameters
- `t` (query, optional, string) - Token id from an email invitation
- `iid` (query, optional, string) - Token id from an invitation link

## Request body
- required: True
- description: User object to be created
- content:
  - `application/json` -> object

## Responses
- `201`: User creation successful
  - `application/json` -> User
- `400`: No description available.
- `403`: No description available.
