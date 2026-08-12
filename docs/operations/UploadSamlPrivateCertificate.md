# Upload private key

Original OpenAPI operationId: `UploadSamlPrivateCertificate`
- Method: `POST`
- Path: `/api/v4/saml/certificate/private`
- Summary: Upload private key
- Description: Upload the private key to be used for encryption with your SAML configuration. The server will pick a hard-coded filename for the PrivateKeyFile setting in your `config.json`.
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
