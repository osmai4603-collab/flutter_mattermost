# Get an outgoing webhook

Original OpenAPI operationId: `GetOutgoingWebhook`
- Method: `GET`
- Path: `/api/v4/hooks/outgoing/{hook_id}`
- Summary: Get an outgoing webhook
- Description: Get an outgoing webhook given the hook id.
##### Permissions
`manage_webhooks` for system or `manage_webhooks` for the specific team or `manage_webhooks` for the channel.

- Tags: webhooks

## Parameters
- `hook_id` (path, required, string) - Outgoing webhook GUID

## Request body
No request body.

## Responses
- `200`: Outgoing webhook retrieval successful
  - `application/json` -> OutgoingWebhook
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
