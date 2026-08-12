# Update an outgoing webhook

Original OpenAPI operationId: `UpdateOutgoingWebhook`
- Method: `PUT`
- Path: `/api/v4/hooks/outgoing/{hook_id}`
- Summary: Update an outgoing webhook
- Description: Update an outgoing webhook given the hook id.
##### Permissions
`manage_webhooks` for system or `manage_webhooks` for the specific team or `manage_webhooks` for the channel.

- Tags: webhooks

## Parameters
- `hook_id` (path, required, string) - outgoing Webhook GUID

## Request body
- required: True
- description: Outgoing webhook to be updated
- content:
  - `application/json` -> object

## Responses
- `200`: Webhook update successful
  - `application/json` -> OutgoingWebhook
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
