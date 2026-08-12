# Test LDAP configuration

Original OpenAPI operationId: `TestLdap`
- Method: `POST`
- Path: `/api/v4/ldap/test`
- Summary: Test LDAP configuration
- Description: Test the current AD/LDAP configuration to see if the AD/LDAP server can be contacted successfully.
##### Permissions
Must have `manage_system` permission.

- Tags: LDAP

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: LDAP test successful
  - `application/json` -> StatusOK
- `500`: No description available.
- `501`: No description available.
