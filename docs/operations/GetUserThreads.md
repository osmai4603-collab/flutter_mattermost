# Get all threads that user is following

Original OpenAPI operationId: `GetUserThreads`
- Method: `GET`
- Path: `/api/v4/users/{user_id}/teams/{team_id}/threads`
- Summary: Get all threads that user is following
- Description: Get all threads that user is following

__Minimum server version__: 5.29

##### Permissions
Must be logged in as the user or have `edit_other_users` permission.

- Tags: threads

## Parameters
- `user_id` (path, required, string) - The ID of the user. This can also be "me" which will point to the current user.
- `team_id` (path, required, string) - The ID of the team in which the thread is.
- `since` (query, optional, integer) - Since filters the threads based on their LastUpdateAt timestamp.
- `deleted` (query, optional, boolean) - Deleted will specify that even deleted threads should be returned (For mobile sync).
- `extended` (query, optional, boolean) - Extended will enrich the response with participant details.
- `page` (query, optional, integer) - Page specifies which part of the results to return, by per_page.
- `per_page` (query, optional, integer) - The size of the returned chunk of results.
- `totalsOnly` (query, optional, boolean) - Setting this to true will only return the total counts.
- `threadsOnly` (query, optional, boolean) - Setting this to true will only return threads.

## Request body
No request body.

## Responses
- `200`: User's thread retrieval successful
  - `application/json` -> UserThreads
- `400`: No description available.
- `401`: No description available.
- `404`: No description available.
