# Bulk get the reaction for posts

Original OpenAPI operationId: `GetBulkReactions`
- Method: `POST`
- Path: `/api/v4/posts/ids/reactions`
- Summary: Bulk get the reaction for posts
- Description: Get a list of reactions made by all users to a given post.
##### Permissions
Must have `read_channel` permission for the channel the post is in.

__Minimum server version__: 5.8

- Tags: reactions

## Parameters
No parameters.

## Request body
- required: True
- description: Array of post IDs
- content:
  - `application/json` -> array of string

## Responses
- `200`: Reactions retrieval successful
  - `application/json` -> PostIdToReactionsMap
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
