# Get posts by a list of ids

Original OpenAPI operationId: `getPostsByIds`
- Method: `POST`
- Path: `/api/v4/posts/ids`
- Summary: Get posts by a list of ids
- Description: Fetch a list of posts based on the provided postIDs
##### Permissions
Must have `read_channel` permission for the channel the post is in or if the channel is public, have the `read_public_channels` permission for the team.

- Tags: posts

## Parameters
No parameters.

## Request body
- required: True
- description: List of post ids
- content:
  - `application/json` -> array of string

## Responses
- `200`: Post list retrieval successful
  - `application/json` -> array of Post
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
