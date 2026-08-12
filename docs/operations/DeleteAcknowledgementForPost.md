# Delete a post acknowledgement

Original OpenAPI operationId: `DeleteAcknowledgementForPost`
- Method: `DELETE`
- Path: `/api/v4/users/{user_id}/posts/{post_id}/ack`
- Summary: Delete a post acknowledgement
- Description: Delete an acknowledgement form a post that you had previously acknowledged.
##### Permissions
Must have `read_channel` permission for the channel the post is in.<br/> Must be logged in as the user or have `edit_other_users` permission.<br/> The post must have been acknowledged in the previous 5 minutes.

__Minimum server version__: 7.7

- Tags: posts

## Parameters
- `user_id` (path, required, string) - User GUID
- `post_id` (path, required, string) - Post GUID

## Request body
No request body.

## Responses
- `200`: Acknowledgement deleted successfully
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
