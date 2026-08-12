# Reveal a burn-on-read post

Original OpenAPI operationId: `RevealPost`
- Method: `GET`
- Path: `/api/v4/posts/{post_id}/reveal`
- Summary: Reveal a burn-on-read post
- Description: Reveal a burn-on-read post. This endpoint allows a user to reveal a post that was created with burn-on-read functionality. Once revealed, the post content becomes visible to the user. If the post is already revealed and not expired, this is a no-op. If the post has expired, an error will be returned.
##### Permissions
Must have `read_channel` permission for the channel the post is in.<br/> Must be a member of the channel the post is in.<br/> Cannot reveal your own post.
##### Feature Flag
Requires `BurnOnRead` feature flag and Enterprise Advanced license.
__Minimum server version__: 11.2

- Tags: posts

## Parameters
- `post_id` (path, required, string) - The identifier of the post to reveal

## Request body
No request body.

## Responses
- `200`: Post revealed successfully
  - `application/json` -> Post
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
