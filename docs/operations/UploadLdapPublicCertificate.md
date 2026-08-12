# Upload public certificate

Original OpenAPI operationId: `UploadLdapPublicCertificate`
- Method: `POST`
- Path: `/api/v4/ldap/certificate/public`
- Summary: Upload public certificate
- Description: Upload the public certificate to be used for TLS verification. The server will pick a hard-coded filename for the PublicCertificateFile setting in your `config.json`.
##### Permissions
Must have `manage_system` permission.

- Tags: LDAP

## Parameters
No parameters.

## Request body
- required: False
- content:
  - `multipart/form-data` -> object

## Responses
- `200`: LDAP certificate upload successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
