# Get a thread

Original OpenAPI operationId: `GetPostThread`
- Method: `GET`
- Path: `/api/v4/posts/{post_id}/thread`
- Summary: Get a thread
- Description: Get a post and the rest of the posts in the same thread.
##### Permissions
Must have `read_channel` permission for the channel the post is in or if the channel is public, have the `read_public_channels` permission for the team.

- Tags: posts

## Parameters
- `post_id` (path, required, string) - ID of a post in the thread
- `perPage` (query, optional, integer) - The number of posts per page
- `fromPost` (query, optional, string) - The post_id to return the next page of posts from
- `fromCreateAt` (query, optional, integer) - The create_at timestamp to return the next page of posts from
- `fromUpdateAt` (query, optional, integer) - The update_at timestamp to return the next page of posts from. You cannot set this flag with direction=down.
- `direction` (query, optional, string) - The direction to return the posts. Either up or down.
- `skipFetchThreads` (query, optional, boolean) - Whether to skip fetching threads or not
- `collapsedThreads` (query, optional, boolean) - Whether the client uses CRT or not
- `collapsedThreadsExtended` (query, optional, boolean) - Whether to return the associated users as part of the response or not
- `updatesOnly` (query, optional, boolean) - This flag is used to make the API work with the updateAt value. If you set this flag, you must set a value for fromUpdateAt.

## Request body
No request body.

## Responses
- `200`: Post list retrieval successful
  - `application/json` -> PostList
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
