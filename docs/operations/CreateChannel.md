# Create a channel

Original OpenAPI operationId: `CreateChannel`
- Method: `POST`
- Path: `/api/v4/channels`
- Summary: Create a channel
- Description: Create a new channel.
##### Permissions
If creating a public channel, `create_public_channel` permission is required. If creating a private channel, `create_private_channel` permission is required.

- Tags: channels

## Parameters
No parameters.

## Request body
- required: True
- description: Channel object to be created
- content:
  - `application/json` -> object

## Responses
- `201`: Channel creation successful
  - `application/json` -> Channel
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
