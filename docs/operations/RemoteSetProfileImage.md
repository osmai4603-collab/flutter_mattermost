# Set profile image for a remote user.

Original OpenAPI operationId: `RemoteSetProfileImage`
- Method: `POST`
- Path: `/api/v4/remotecluster/{user_id}/image`
- Summary: Set profile image for a remote user.
- Description: Uploads and sets a profile image for a remote user managed by the
requesting remote cluster. This endpoint is authenticated with a
remote-cluster token.

##### Permissions
No user session permissions required.

- Tags: remote clusters

## Parameters
- `user_id` (path, required, string) - The remote user ID.

## Request body
- required: False
- content:
  - `multipart/form-data` -> object

## Responses
- `200`: Profile image updated successfully
- `400`: No description available.
- `401`: No description available.
