# Get current usage of posts

Original OpenAPI operationId: `GetPostsUsage`
- Method: `GET`
- Path: `/api/v4/usage/posts`
- Summary: Get current usage of posts
- Description: Retrieve rounded off total no. of posts for this instance. Example: returns 4000 instead of 4321
##### Permissions
Must be authenticated.
__Minimum server version__: 7.0

- Tags: usage

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Total no. of posts returned successfully
  - `application/json` -> PostsUsage
- `401`: No description available.
- `500`: No description available.
