# Get posts for a view

Original OpenAPI operationId: `GetPostsForView`
- Method: `GET`
- Path: `/api/v4/channels/{channel_id}/views/{view_id}/posts`
- Summary: Get posts for a view
- Description: *__Experimental__: This endpoint is experimental and may change or be removed in a future release.*

Get a paginated list of posts that belong to a specific view.

__Minimum server version__: 11.6

##### Permissions
Must have `read_channel_content` permission for the channel.

- Tags: views

## Parameters
- `channel_id` (path, required, string) - Channel GUID
- `view_id` (path, required, string) - View GUID
- `page` (query, optional, integer) - The 0-based page number for pagination (default 0)
- `per_page` (query, optional, integer) - The number of posts per page (default 60, max 200)

## Request body
No request body.

## Responses
- `200`: Post list retrieval successful
  - `application/json` -> PostList
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `500`: No description available.
