# Create channel view

Original OpenAPI operationId: `CreateChannelView`
- Method: `POST`
- Path: `/api/v4/channels/{channel_id}/views`
- Summary: Create channel view
- Description: *__Experimental__: This endpoint is experimental and may change or be removed in a future release.*

Create a new view for a channel.

__Minimum server version__: 11.6

##### Permissions
Must have `create_post` permission for the channel.

- Tags: views

## Parameters
- `channel_id` (path, required, string) - Channel GUID

## Request body
- required: True
- description: View object to be created
- content:
  - `application/json` -> object

## Responses
- `201`: Channel view creation successful
  - `application/json` -> View
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `500`: No description available.
