# Remove private key

Original OpenAPI operationId: `DeleteLdapPrivateCertificate`
- Method: `DELETE`
- Path: `/api/v4/ldap/certificate/private`
- Summary: Remove private key
- Description: Delete the current private key being used with your TLS verification.
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
