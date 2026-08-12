# Delete user's recent custom status

Original OpenAPI operationId: `RemoveRecentCustomStatus`
- Method: `DELETE`
- Path: `/api/v4/users/{user_id}/status/custom/recent`
- Summary: Delete user's recent custom status
- Description: Deletes a user's recent custom status by removing the specific status from the recentCustomStatuses in the user's props and updates the user.
##### Permissions
Must be logged in as the user whose recent custom status is being deleted.

- Tags: status

## Parameters
- `user_id` (path, required, string) - User ID

## Request body
- required: True
- description: Custom Status object that is to be removed from the recent custom statuses.
- content:
  - `application/json` -> object

## Responses
- `200`: User recent custom status delete successful
- `400`: No description available.
- `401`: No description available.
