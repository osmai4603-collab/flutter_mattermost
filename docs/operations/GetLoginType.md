# Get login authentication type

Original OpenAPI operationId: `GetLoginType`
- Method: `POST`
- Path: `/api/v4/users/login/type`
- Summary: Get login authentication type
- Description: Get the authentication service type (auth_service) for a user to determine how they should authenticate. This endpoint is typically used in the login flow to determine which authentication method to use.

For this version, the endpoint only returns a non-empty `auth_service` if the user has magic_link enabled. For all other authentication methods (email/password, OAuth, SAML, LDAP), an empty string is returned.
##### Permissions
No permission required

- Tags: users

## Parameters
No parameters.

## Request body
- required: True
- description: Login type request object
- content:
  - `application/json` -> object

## Responses
- `200`: Login type retrieved successfully
  - `application/json` -> object
- `400`: No description available.
