# Update user status

Original OpenAPI operationId: `UpdateUserStatus`
- Method: `PUT`
- Path: `/api/v4/users/{user_id}/status`
- Summary: Update user status
- Description: Manually set a user's status. When setting a user's status, the status will remain that value until set "online" again, which will return the status to being automatically updated based on user activity.
##### Permissions
Must have `edit_other_users` permission for the team.

- Tags: status

## Parameters
- `user_id` (path, required, string) - User ID

## Request body
- required: True
- description: Status object that is to be updated
- content:
  - `application/json` -> object

## Responses
- `200`: User status update successful
  - `application/json` -> Status
- `400`: No description available.
- `401`: No description available.
