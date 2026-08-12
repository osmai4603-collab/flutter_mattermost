# Mark a thread that user is following read state to the timestamp

Original OpenAPI operationId: `UpdateThreadReadForUser`
- Method: `PUT`
- Path: `/api/v4/users/{user_id}/teams/{team_id}/threads/{thread_id}/read/{timestamp}`
- Summary: Mark a thread that user is following read state to the timestamp
- Description: Mark a thread that user is following as read

__Minimum server version__: 5.29

##### Permissions
Must be logged in as the user or have `edit_other_users` permission.

- Tags: threads

## Parameters
- `user_id` (path, required, string) - The ID of the user. This can also be "me" which will point to the current user.
- `team_id` (path, required, string) - The ID of the team in which the thread is.
- `thread_id` (path, required, string) - The ID of the thread to update
- `timestamp` (path, required, string) - The timestamp to which the thread's "last read" state will be reset.

## Request body
No request body.

## Responses
- `200`: User's thread update successful
- `400`: No description available.
- `401`: No description available.
- `404`: No description available.
