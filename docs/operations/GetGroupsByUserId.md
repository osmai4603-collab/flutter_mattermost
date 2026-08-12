# Get groups for a userId

Original OpenAPI operationId: `GetGroupsByUserId`
- Method: `GET`
- Path: `/api/v4/users/{user_id}/groups`
- Summary: Get groups for a userId
- Description: Retrieve the list of groups associated to the user

__Minimum server version__: 5.24

- Tags: groups

## Parameters
- `user_id` (path, required, string) - User GUID

## Request body
No request body.

## Responses
- `200`: Group list retrieval successful
  - `application/json` -> array of Group
- `400`: No description available.
- `501`: No description available.
