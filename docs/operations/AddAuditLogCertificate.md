# Upload audit log certificate

Original OpenAPI operationId: `AddAuditLogCertificate`
- Method: `POST`
- Path: `/api/v4/audit_logs/certificate`
- Summary: Upload audit log certificate
- Description: Upload the certificate to be used for TLS verification with the audit log service.

##### Permissions
Must have `sysconsole_write_experimental_features` permission.

__Minimum server version__: 10.9

- Tags: audit_logs

## Parameters
No parameters.

## Request body
- required: False
- content:
  - `multipart/form-data` -> object

## Responses
- `200`: Certificate upload successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `413`: No description available.
- `501`: No description available.
