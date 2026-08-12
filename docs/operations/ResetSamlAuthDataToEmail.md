# Reset AuthData to Email

Original OpenAPI operationId: `ResetSamlAuthDataToEmail`
- Method: `POST`
- Path: `/api/v4/saml/reset_auth_data`
- Summary: Reset AuthData to Email
- Description: Reset the AuthData field of SAML users to their email. This is meant to be used when the "id" attribute is set to an empty value ("") from a previously non-empty value.
__Minimum server version__: 5.35
##### Permissions
Must have `manage_system` permission.

- Tags: SAML

## Parameters
No parameters.

## Request body
- required: False
- content:
  - `application/json` -> object

## Responses
- `200`: AuthData successfully reset
  - `application/json` -> object
- `403`: No description available.
- `501`: No description available.
