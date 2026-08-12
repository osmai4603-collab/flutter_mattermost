# Get a channel view

Original OpenAPI operationId: `GetChannelView`
- Method: `GET`
- Path: `/api/v4/channels/{channel_id}/views/{view_id}`
- Summary: Get a channel view
- Description: *__Experimental__: This endpoint is experimental and may change or be removed in a future release.*

Get a single view by its ID.

__Minimum server version__: 11.6

##### Permissions
Must have `read_channel_content` permission for the channel.

- Tags: views

## Parameters
- `channel_id` (path, required, string) - Channel GUID
- `view_id` (path, required, string) - View GUID

## Request body
No request body.

## Responses
- `200`: Channel view retrieval successful
  - `application/json` -> View
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `500`: No description available.
