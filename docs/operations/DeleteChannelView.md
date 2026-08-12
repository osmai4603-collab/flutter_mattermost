# Delete a channel view

Original OpenAPI operationId: `DeleteChannelView`
- Method: `DELETE`
- Path: `/api/v4/channels/{channel_id}/views/{view_id}`
- Summary: Delete a channel view
- Description: *__Experimental__: This endpoint is experimental and may change or be removed in a future release.*

Soft-deletes a channel view. Sets `delete_at` to current timestamp.

__Minimum server version__: 11.6

##### Permissions
Must have `create_post` permission for the channel.

- Tags: views

## Parameters
- `channel_id` (path, required, string) - Channel GUID
- `view_id` (path, required, string) - View GUID

## Request body
No request body.

## Responses
- `200`: Channel view deletion successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `500`: No description available.
