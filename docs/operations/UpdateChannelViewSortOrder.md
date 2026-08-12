# Update a channel view's sort order

Original OpenAPI operationId: `UpdateChannelViewSortOrder`
- Method: `POST`
- Path: `/api/v4/channels/{channel_id}/views/{view_id}/sort_order`
- Summary: Update a channel view's sort order
- Description: *__Experimental__: This endpoint is experimental and may change or be removed in a future release.*

Updates the sort order of a channel view, setting its new index
from the request body and updating the rest of the views in the
channel to accommodate the change.

__Minimum server version__: 11.6

##### Permissions
Must have `create_post` permission for the channel.

- Tags: views

## Parameters
- `channel_id` (path, required, string) - Channel GUID
- `view_id` (path, required, string) - View GUID

## Request body
- required: True
- content:
  - `application/json` -> integer

## Responses
- `200`: Channel view sort order update successful
  - `application/json` -> array of View
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `500`: No description available.
