# Create a group message channel

Original OpenAPI operationId: `CreateGroupChannel`
- Method: `POST`
- Path: `/api/v4/channels/group`
- Summary: Create a group message channel
- Description: Create a new group message channel to group of users. If the logged in user's id is not included in the list, it will be appended to the end.
##### Permissions
Must have `create_group_channel` permission.

- Tags: channels

## Parameters
No parameters.

## Request body
- required: True
- description: User ids to be in the group message channel.
- content:
  - `application/json` -> array of string

## Responses
- `201`: Group channel creation successful
  - `application/json` -> Channel
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
