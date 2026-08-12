# Creates a scheduled post

Original OpenAPI operationId: `CreateScheduledPost`
- Method: `POST`
- Path: `/api/v4/posts/schedule`
- Summary: Creates a scheduled post
- Description: Creates a scheduled post
##### Permissions
Must have `create_post` permission for the channel the post is being created in.
__Minimum server version__: 10.3

- Tags: scheduled_post

## Parameters
No parameters.

## Request body
- required: False
- content:
  - `application/json` -> object

## Responses
- `200`: Created scheduled post
  - `application/json` -> object
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
