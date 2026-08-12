# Move a channel

Original OpenAPI operationId: `MoveChannel`
- Method: `POST`
- Path: `/api/v4/channels/{channel_id}/move`
- Summary: Move a channel
- Description: Move a channel to another team.

__Minimum server version__: 5.26

##### Permissions

Must have `manage_system` permission.

- Tags: channels

## Parameters
- `channel_id` (path, required, string) - Channel GUID

## Request body
- required: True
- content:
  - `application/json` -> object

## Responses
- `200`: Channel move successful
  - `application/json` -> Channel
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
