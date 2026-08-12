# Remove public certificate

Original OpenAPI operationId: `DeleteSamlPublicCertificate`
- Method: `DELETE`
- Path: `/api/v4/saml/certificate/public`
- Summary: Remove public certificate
- Description: Delete the current public certificate being used with your SAML configuration. This will also disable encryption for SAML on your system as this certificate is required for that.
##### Permissions
Must have `sysconsole_write_authentication` permission.

- Tags: SAML

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: SAML certificate delete successful
  - `application/json` -> StatusOK
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
