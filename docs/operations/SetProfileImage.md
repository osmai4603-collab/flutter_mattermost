# Set user's profile image

Original OpenAPI operationId: `SetProfileImage`
- Method: `POST`
- Path: `/api/v4/users/{user_id}/image`
- Summary: Set user's profile image
- Description: Set a user's profile image based on user_id string parameter.
##### Permissions
Must be logged in as the user being updated or have the `edit_other_users` permission.

- Tags: users

## Parameters
- `user_id` (path, required, string) - User GUID

## Request body
- required: False
- content:
  - `multipart/form-data` -> object

## Responses
- `200`: Profile image set successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `501`: No description available.
