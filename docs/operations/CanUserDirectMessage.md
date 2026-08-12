# Check if user can DM another user in shared channels context

Original OpenAPI operationId: `CanUserDirectMessage`
- Method: `GET`
- Path: `/api/v4/sharedchannels/users/{user_id}/can_dm/{other_user_id}`
- Summary: Check if user can DM another user in shared channels context
- Description: Checks if a user can send direct messages to another user in a shared channels context.
In addition to user visibility, this evaluates remote-cluster direct-connect restrictions
for remote users.

__Minimum server version__: 10.11

##### Permissions
Must be authenticated and able to view the target user.

- Tags: shared channels

## Parameters
- `user_id` (path, required, string) - User GUID
- `other_user_id` (path, required, string) - Other user GUID

## Request body
No request body.

## Responses
- `200`: DM permission check successful
  - `application/json` -> object
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
