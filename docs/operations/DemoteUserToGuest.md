# Demote a user to a guest

Original OpenAPI operationId: `DemoteUserToGuest`
- Method: `POST`
- Path: `/api/v4/users/{user_id}/demote`
- Summary: Demote a user to a guest
- Description: Convert a regular user into a guest. This will convert the user into a
guest for the whole system while retaining their existing team and
channel memberships.

__Minimum server version__: 5.16

##### Permissions
Must be logged in as the user or have the `demote_to_guest` permission.

- Tags: users

## Parameters
- `user_id` (path, required, string) - User GUID

## Request body
No request body.

## Responses
- `200`: User successfully demoted
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `501`: No description available.
