# Get user's profile image

Original OpenAPI operationId: `GetProfileImage`
- Method: `GET`
- Path: `/api/v4/users/{user_id}/image`
- Summary: Get user's profile image
- Description: Get a user's profile image based on user_id string parameter.
##### Permissions
Must be logged in.

- Tags: users

## Parameters
- `user_id` (path, required, string) - User GUID
- `_` (query, optional, number) - Not used by the server. Clients can pass in the last picture update time of the user to potentially take advantage of caching

## Request body
No request body.

## Responses
- `200`: User's profile image
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `501`: No description available.
