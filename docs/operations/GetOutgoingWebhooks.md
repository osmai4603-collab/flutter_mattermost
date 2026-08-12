# List outgoing webhooks

Original OpenAPI operationId: `GetOutgoingWebhooks`
- Method: `GET`
- Path: `/api/v4/hooks/outgoing`
- Summary: List outgoing webhooks
- Description: Get a page of a list of outgoing webhooks. Optionally filter for a specific team or channel using query parameters.
##### Permissions
`manage_webhooks` for the system or `manage_webhooks` for the specific team/channel.

- Tags: webhooks

## Parameters
- `page` (query, optional, integer) - The page to select.
- `per_page` (query, optional, integer) - The number of hooks per page.
- `team_id` (query, optional, string) - The ID of the team to get hooks for.
- `channel_id` (query, optional, string) - The ID of the channel to get hooks for.

## Request body
No request body.

## Responses
- `200`: Outgoing webhooks retrieval successful
  - `application/json` -> array of OutgoingWebhook
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
