# Update user custom status

Original OpenAPI operationId: `UpdateUserCustomStatus`
- Method: `PUT`
- Path: `/api/v4/users/{user_id}/status/custom`
- Summary: Update user custom status
- Description: Updates a user's custom status by setting the value in the user's props and updates the user. Also save the given custom status to the recent custom statuses in the user's props
##### Permissions
Must be logged in as the user whose custom status is being updated.

- Tags: status

## Parameters
- `user_id` (path, required, string) - User ID

## Request body
- required: True
- description: Custom status object that is to be updated
- content:
  - `application/json` -> object

## Responses
- `200`: User custom status update successful
- `400`: No description available.
- `401`: No description available.
