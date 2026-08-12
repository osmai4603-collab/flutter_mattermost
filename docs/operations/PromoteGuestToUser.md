# Promote a guest to user

Original OpenAPI operationId: `PromoteGuestToUser`
- Method: `POST`
- Path: `/api/v4/users/{user_id}/promote`
- Summary: Promote a guest to user
- Description: Convert a guest into a regular user. This will convert the guest into a
user for the whole system while retaining any team and channel
memberships and automatically joining them to the default channels.

__Minimum server version__: 5.16

##### Permissions
Must be logged in as the user or have the `promote_guest` permission.

- Tags: users

## Parameters
- `user_id` (path, required, string) - User GUID

## Request body
No request body.

## Responses
- `200`: Guest successfully promoted
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `501`: No description available.
