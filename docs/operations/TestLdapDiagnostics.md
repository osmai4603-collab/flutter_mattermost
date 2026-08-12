# Test LDAP diagnostics with specific settings

Original OpenAPI operationId: `TestLdapDiagnostics`
- Method: `POST`
- Path: `/api/v4/ldap/test_diagnostics`
- Summary: Test LDAP diagnostics with specific settings
- Description: Test LDAP diagnostics using the provided settings to validate configuration and see sample results without modifying the current server configuration. Use the `test` query parameter to specify which diagnostic to run.
##### Permissions
Must have `sysconsole_read_authentication_ldap` or `manage_system` permission.

- Tags: LDAP

## Parameters
- `test` (query, required, string) - Type of LDAP diagnostic test to run

## Request body
- required: True
- description: LDAP settings to test diagnostics with
- content:
  - `application/json` -> LdapSettings

## Responses
- `200`: LDAP diagnostic test results
  - `application/json` -> array of LdapDiagnosticResult
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
- `501`: No description available.
