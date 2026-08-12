# Acknowledge a post

Original OpenAPI operationId: `SaveAcknowledgementForPost`
- Method: `POST`
- Path: `/api/v4/users/{user_id}/posts/{post_id}/ack`
- Summary: Acknowledge a post
- Description: Acknowledge a post that has a request for acknowledgements.
##### Permissions
Must have `read_channel` permission for the channel the post is in.<br/> Must be logged in as the user or have `edit_other_users` permission.

__Minimum server version__: 7.7

- Tags: posts

## Parameters
- `user_id` (path, required, string) - User GUID
- `post_id` (path, required, string) - Post GUID

## Request body
No request body.

## Responses
- `200`: Acknowledgement saved successfully
  - `application/json` -> PostAcknowledgement
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
