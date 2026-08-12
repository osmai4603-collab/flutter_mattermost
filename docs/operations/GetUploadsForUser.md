# Get uploads for a user

Original OpenAPI operationId: `GetUploadsForUser`
- Method: `GET`
- Path: `/api/v4/users/{user_id}/uploads`
- Summary: Get uploads for a user
- Description: Gets all the upload sessions belonging to a user.

__Minimum server version__: 5.28

##### Permissions
Must be logged in as the user who created the upload sessions.

- Tags: users

## Parameters
- `user_id` (path, required, string) - The ID of the user. This can also be "me" which will point to the current user.

## Request body
No request body.

## Responses
- `200`: User's uploads retrieval successful
  - `application/json` -> array of UploadSession
- `400`: No description available.
- `401`: No description available.
- `404`: No description available.
