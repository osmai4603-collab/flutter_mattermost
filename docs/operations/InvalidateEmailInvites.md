# Invalidate active email invitations

Original OpenAPI operationId: `InvalidateEmailInvites`
- Method: `DELETE`
- Path: `/api/v4/teams/invites/email`
- Summary: Invalidate active email invitations
- Description: Invalidate active email invitations that have not been accepted by the user.
##### Permissions
Must have `sysconsole_write_authentication` permission.

- Tags: teams

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Email invites successfully revoked
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
