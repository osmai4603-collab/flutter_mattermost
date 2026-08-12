# Publish a user typing websocket event.

Original OpenAPI operationId: `PublishUserTyping`
- Method: `POST`
- Path: `/api/v4/users/{user_id}/typing`
- Summary: Publish a user typing websocket event.
- Description: Notify users in the given channel via websocket that the given user is typing.
__Minimum server version__: 5.26
##### Permissions
Must have `manage_system` permission to publish for any user other than oneself.

- Tags: users

## Parameters
- `user_id` (path, required, string) - User GUID

## Request body
- required: False
- content:
  - `application/json` -> object

## Responses
- `200`: User typing websocket event accepted for publishing.
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
