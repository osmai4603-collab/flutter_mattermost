# Return user's default (generated) profile image

Original OpenAPI operationId: `GetDefaultProfileImage`
- Method: `GET`
- Path: `/api/v4/users/{user_id}/image/default`
- Summary: Return user's default (generated) profile image
- Description: Returns the default (generated) user profile image based on user_id string parameter.
##### Permissions
Must be logged in.
__Minimum server version__: 5.5

- Tags: users

## Parameters
- `user_id` (path, required, string) - User GUID

## Request body
No request body.

## Responses
- `200`: Default profile image
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `501`: No description available.
