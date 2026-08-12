# Test LDAP connection with specific settings

Original OpenAPI operationId: `TestLdapConnection`
- Method: `POST`
- Path: `/api/v4/ldap/test_connection`
- Summary: Test LDAP connection with specific settings
- Description: Test the LDAP connection using the provided settings without modifying the current server configuration.
##### Permissions
Must have `sysconsole_read_authentication_ldap` or `manage_system` permission.

- Tags: LDAP

## Parameters
No parameters.

## Request body
- required: True
- description: LDAP settings to test
- content:
  - `application/json` -> LdapSettings

## Responses
- `200`: LDAP connection test successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
- `501`: No description available.
