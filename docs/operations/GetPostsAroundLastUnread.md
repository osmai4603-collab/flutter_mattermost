# Get posts around oldest unread

Original OpenAPI operationId: `GetPostsAroundLastUnread`
- Method: `GET`
- Path: `/api/v4/users/{user_id}/channels/{channel_id}/posts/unread`
- Summary: Get posts around oldest unread
- Description: Get the oldest unread post in the channel for the given user as well as the posts around it. The returned list is sorted in descending order (most recent post first).
##### Permissions
Must be logged in as the user or have `edit_other_users` permission, and must have `read_channel` permission for the channel.
__Minimum server version__: 5.14

- Tags: posts

## Parameters
- `user_id` (path, required, string) - ID of the user
- `channel_id` (path, required, string) - The channel ID to get the posts for
- `limit_before` (query, optional, integer) - Number of posts before the oldest unread posts. Maximum is 200 posts if limit is set greater than that.
- `limit_after` (query, optional, integer) - Number of posts after and including the oldest unread post. Maximum is 200 posts if limit is set greater than that.
- `skipFetchThreads` (query, optional, boolean) - Whether to skip fetching threads or not
- `collapsedThreads` (query, optional, boolean) - Whether the client uses CRT or not
- `collapsedThreadsExtended` (query, optional, boolean) - Whether to return the associated users as part of the response or not

## Request body
No request body.

## Responses
- `200`: Post list retrieval successful
  - `application/json` -> PostList
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
