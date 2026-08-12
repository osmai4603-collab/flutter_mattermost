# Remove public certificate

Original OpenAPI operationId: `DeleteLdapPublicCertificate`
- Method: `DELETE`
- Path: `/api/v4/ldap/certificate/public`
- Summary: Remove public certificate
- Description: Delete the current public certificate being used for TLS verification.
##### Permissions
Must have `manage_system` permission.

- Tags: LDAP

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: LDAP certificate delete successful
  - `application/json` -> StatusOK
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
