# Update a scheduled post

Original OpenAPI operationId: `UpdateScheduledPost`
- Method: `PUT`
- Path: `/api/v4/posts/schedule/{scheduled_post_id}`
- Summary: Update a scheduled post
- Description: Updates a scheduled post
##### Permissions
Must have `create_post` permission for the channel where the scheduled post belongs to.
__Minimum server version__: 10.3

- Tags: scheduled_post

## Parameters
- `scheduled_post_id` (path, required, string) - ID of the scheduled post to update

## Request body
- required: False
- content:
  - `application/json` -> object

## Responses
- `200`: Updated scheduled post
  - `application/json` -> object
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
