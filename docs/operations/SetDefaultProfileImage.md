# Delete user's profile image

Original OpenAPI operationId: `SetDefaultProfileImage`
- Method: `DELETE`
- Path: `/api/v4/users/{user_id}/image`
- Summary: Delete user's profile image
- Description: Delete user's profile image and reset to default image based on user_id string parameter.
##### Permissions
Must be logged in as the user being updated or have the `edit_other_users` permission.
__Minimum server version__: 5.5

- Tags: users

## Parameters
- `user_id` (path, required, string) - User GUID

## Request body
No request body.

## Responses
- `200`: Profile image reset successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `501`: No description available.
