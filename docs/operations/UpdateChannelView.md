# Update a channel view

Original OpenAPI operationId: `UpdateChannelView`
- Method: `PATCH`
- Path: `/api/v4/channels/{channel_id}/views/{view_id}`
- Summary: Update a channel view
- Description: *__Experimental__: This endpoint is experimental and may change or be removed in a future release.*

Partially update a channel view by providing only the fields
you want to update. Omitted fields will not be updated.

__Minimum server version__: 11.6

##### Permissions
Must have `create_post` permission for the channel.

- Tags: views

## Parameters
- `channel_id` (path, required, string) - Channel GUID
- `view_id` (path, required, string) - View GUID

## Request body
- required: True
- description: View fields to be updated
- content:
  - `application/json` -> ViewPatch

## Responses
- `200`: Channel view update successful
  - `application/json` -> View
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `500`: No description available.
