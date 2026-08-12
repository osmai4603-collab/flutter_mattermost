# Sync with LDAP

Original OpenAPI operationId: `SyncLdap`
- Method: `POST`
- Path: `/api/v4/ldap/sync`
- Summary: Sync with LDAP
- Description: Synchronize any user attribute changes in the configured AD/LDAP server with Mattermost.
##### Permissions
Must have `manage_system` permission.

- Tags: LDAP

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: LDAP sync successful
  - `application/json` -> StatusOK
- `501`: No description available.
