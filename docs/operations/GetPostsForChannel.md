# Get posts for a channel

Original OpenAPI operationId: `GetPostsForChannel`
- Method: `GET`
- Path: `/api/v4/channels/{channel_id}/posts`
- Summary: Get posts for a channel
- Description: Get a page of posts in a channel. Use the query parameters to modify the behaviour of this endpoint. The parameter `since` must not be used with any of `before`, `after`, `page`, and `per_page` parameters.
If `since` is used, it will always return all posts modified since that time, ordered by their create time limited till 1000. A caveat with this parameter is that there is no guarantee that the returned posts will be consecutive. It is left to the clients to maintain state and fill any missing holes in the post order.
##### Permissions
Must have `read_channel` permission for the channel.

- Tags: posts

## Parameters
- `channel_id` (path, required, string) - The channel ID to get the posts for
- `page` (query, optional, integer) - The page to select
- `per_page` (query, optional, integer) - The number of posts per page
- `since` (query, optional, integer) - Provide a non-zero value in Unix time milliseconds to select posts modified after that time
- `before` (query, optional, string) - A post id to select the posts that came before this one
- `after` (query, optional, string) - A post id to select the posts that came after this one
- `include_deleted` (query, optional, boolean) - Whether to include deleted posts or not. Must have system admin permissions.
- `type` (query, optional, string) - Filter posts by type.

## Request body
No request body.

## Responses
- `200`: Post list retrieval successful
  - `application/json` -> PostList
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
