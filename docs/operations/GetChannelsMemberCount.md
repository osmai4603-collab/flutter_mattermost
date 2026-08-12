# Get member counts for multiple channels

Original OpenAPI operationId: `GetChannelsMemberCount`
- Method: `POST`
- Path: `/api/v4/channels/stats/member_count`
- Summary: Get member counts for multiple channels
- Description: Get channel member counts for a list of channel IDs.
##### Permissions
Must have access to member count for all requested channels.

- Tags: channels

## Parameters
No parameters.

## Request body
- required: True
- content:
  - `application/json` -> array of string

## Responses
- `200`: Channel member counts retrieval successful
  - `application/json` -> object
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
