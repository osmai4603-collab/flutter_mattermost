# List incoming webhooks

Original OpenAPI operationId: `GetIncomingWebhooks`
- Method: `GET`
- Path: `/api/v4/hooks/incoming`
- Summary: List incoming webhooks
- Description: Get a page of a list of incoming webhooks. Optionally filter for a specific team using query parameters.
##### Permissions
`manage_webhooks` for the system or `manage_webhooks` for the specific team.

- Tags: webhooks

## Parameters
- `page` (query, optional, integer) - The page to select.
- `per_page` (query, optional, integer) - The number of hooks per page.
- `team_id` (query, optional, string) - The ID of the team to get hooks for.
- `include_total_count` (query, optional, boolean) - Appends a total count of returned hooks inside the response object - ex: `{ "incoming_webhooks": [], "total_count": 0 }`.

## Request body
No request body.

## Responses
- `200`: Incoming webhooks retrieval successful
  - `application/json` -> array of IncomingWebhook
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
