# Create memberships for LDAP configured channels and teams for this user

Original OpenAPI operationId: `AddUserToGroupSyncables`
- Method: `POST`
- Path: `/api/v4/ldap/users/{user_id}/group_sync_memberships`
- Summary: Create memberships for LDAP configured channels and teams for this user
- Description: Add the user to each channel and team configured for each LDAP group of whicht the user is a member.
##### Permissions
Must have `sysconsole_write_user_management_groups` permission.

- Tags: LDAP

## Parameters
- `user_id` (path, required, string) - User Id

## Request body
No request body.

## Responses
- `200`: Channel and team memberships created as needed.
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
