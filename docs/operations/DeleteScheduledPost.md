# Delete a scheduled post

Original OpenAPI operationId: `DeleteScheduledPost`
- Method: `DELETE`
- Path: `/api/v4/posts/schedule/{scheduled_post_id}`
- Summary: Delete a scheduled post
- Description: Delete a scheduled post
__Minimum server version__: 10.3

- Tags: scheduled_post

## Parameters
- `scheduled_post_id` (path, required, string) - ID of the scheduled post to delete

## Request body
No request body.

## Responses
- `200`: Deleted scheduled post
  - `application/json` -> object
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
