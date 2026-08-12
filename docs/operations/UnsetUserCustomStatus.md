# Unsets user custom status

Original OpenAPI operationId: `UnsetUserCustomStatus`
- Method: `DELETE`
- Path: `/api/v4/users/{user_id}/status/custom`
- Summary: Unsets user custom status
- Description: Unsets a user's custom status by updating the user's props and updates the user
##### Permissions
Must be logged in as the user whose custom status is being removed.

- Tags: status

## Parameters
- `user_id` (path, required, string) - User ID

## Request body
No request body.

## Responses
- `200`: User custom status delete successful
- `400`: No description available.
- `401`: No description available.
