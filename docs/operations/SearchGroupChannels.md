# Search Group Channels

Original OpenAPI operationId: `SearchGroupChannels`
- Method: `POST`
- Path: `/api/v4/channels/group/search`
- Summary: Search Group Channels
- Description: Get a list of group channels for a user which members' usernames match the search term.

__Minimum server version__: 5.14

- Tags: channels

## Parameters
No parameters.

## Request body
- required: True
- description: Search criteria
- content:
  - `application/json` -> object

## Responses
- `200`: Channels search successful
  - `application/json` -> array of Channel
- `400`: No description available.
- `401`: No description available.
