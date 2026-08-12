# Create a direct message channel

Original OpenAPI operationId: `CreateDirectChannel`
- Method: `POST`
- Path: `/api/v4/channels/direct`
- Summary: Create a direct message channel
- Description: Create a new direct message channel between two users.
##### Permissions
Must be one of the two users and have `create_direct_channel` permission. Having the `manage_system` permission voids the previous requirements.

- Tags: channels

## Parameters
No parameters.

## Request body
- required: True
- description: The two user ids to be in the direct message
- content:
  - `application/json` -> array of string

## Responses
- `201`: Direct channel creation successful
  - `application/json` -> Channel
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
