# Remove IDP certificate

Original OpenAPI operationId: `DeleteSamlIdpCertificate`
- Method: `DELETE`
- Path: `/api/v4/saml/certificate/idp`
- Summary: Remove IDP certificate
- Description: Delete the current IDP certificate being used with your SAML configuration. This will also disable SAML on your system as this certificate is required for SAML.
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
