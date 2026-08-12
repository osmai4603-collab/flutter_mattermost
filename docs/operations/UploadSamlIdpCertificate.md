# Upload IDP certificate

Original OpenAPI operationId: `UploadSamlIdpCertificate`
- Method: `POST`
- Path: `/api/v4/saml/certificate/idp`
- Summary: Upload IDP certificate
- Description: Upload the IDP certificate to be used with your SAML configuration. The server will pick a hard-coded filename for the IdpCertificateFile setting in your `config.json`.
##### Permissions
Must have `sysconsole_write_authentication` permission.

- Tags: SAML

## Parameters
No parameters.

## Request body
- required: False
- content:
  - `multipart/form-data` -> object

## Responses
- `200`: SAML certificate upload successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
