# Burn a burn-on-read post

Original OpenAPI operationId: `BurnPost`
- Method: `DELETE`
- Path: `/api/v4/posts/{post_id}/burn`
- Summary: Burn a burn-on-read post
- Description: Burn a burn-on-read post. This endpoint allows a user to burn a post that was created with burn-on-read functionality. If the user is the author of the post, the post will be permanently deleted. If the user is not the author, the post will be expired for that user by updating their read receipt expiration time. If the user has not revealed the post yet, an error will be returned. If the post is already expired for the user, this is a no-op.
##### Permissions
Must have `read_channel` permission for the channel the post is in.<br/> Must be a member of the channel the post is in.
##### Feature Flag
Requires `BurnOnRead` feature flag and Enterprise Advanced license.
__Minimum server version__: 11.2

- Tags: posts

## Parameters
- `post_id` (path, required, string) - The identifier of the post to burn

## Request body
No request body.

## Responses
- `200`: Post burned successfully
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
