# Remove audit log certificate

Original OpenAPI operationId: `RemoveAuditLogCertificate`
- Method: `DELETE`
- Path: `/api/v4/audit_logs/certificate`
- Summary: Remove audit log certificate
- Description: Delete the current certificate being used with the audit log service.

##### Permissions
Must have `sysconsole_write_experimental_features` permission.

__Minimum server version__: 9.5

- Tags: audit_logs

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Certificate deletion successful
  - `application/json` -> StatusOK
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
