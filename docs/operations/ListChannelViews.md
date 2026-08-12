# List channel views

Original OpenAPI operationId: `ListChannelViews`
- Method: `GET`
- Path: `/api/v4/channels/{channel_id}/views`
- Summary: List channel views
- Description: *__Experimental__: This endpoint is experimental and may change or be removed in a future release.*

Get a list of views for a channel.

__Minimum server version__: 11.6

##### Permissions
Must have `read_channel_content` permission for the channel.

- Tags: views

## Parameters
- `channel_id` (path, required, string) - Channel GUID
- `per_page` (query, optional, integer) - The number of views per page (default 60, max 200)
- `page` (query, optional, integer) - The 0-based page number for pagination (default 0)
- `include_total_count` (query, optional, boolean) - When true, the response is a ViewsWithCount object containing a views array and a total_count integer. When false or omitted, the response is a plain JSON array of View objects.


## Request body
No request body.

## Responses
- `200`: Channel views retrieval successful
  - `application/json` -> object
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `500`: No description available.
