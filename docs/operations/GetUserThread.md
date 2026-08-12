# Get a thread followed by the user

Original OpenAPI operationId: `GetUserThread`
- Method: `GET`
- Path: `/api/v4/users/{user_id}/teams/{team_id}/threads/{thread_id}`
- Summary: Get a thread followed by the user
- Description: Get a thread

__Minimum server version__: 5.29

##### Permissions
Must be logged in as the user or have `edit_other_users` permission.

- Tags: threads

## Parameters
- `user_id` (path, required, string) - The ID of the user. This can also be "me" which will point to the current user.
- `team_id` (path, required, string) - The ID of the team in which the thread is.
- `thread_id` (path, required, string) - The ID of the thread to follow

## Request body
No request body.

## Responses
- `200`: Get was successful
- `400`: No description available.
- `401`: No description available.
- `404`: No description available.
