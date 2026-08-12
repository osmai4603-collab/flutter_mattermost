# Get certificate status

Original OpenAPI operationId: `GetSamlCertificateStatus`
- Method: `GET`
- Path: `/api/v4/saml/certificate/status`
- Summary: Get certificate status
- Description: Get the status of the uploaded certificates and keys in use by your SAML configuration.
##### Permissions
Must have `sysconsole_write_authentication` permission.

- Tags: SAML

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: SAML certificate status retrieval successful
  - `application/json` -> SamlCertificateStatus
- `403`: No description available.
- `501`: No description available.
