# Update an incoming webhook

Original OpenAPI operationId: `UpdateIncomingWebhook`
- Method: `PUT`
- Path: `/api/v4/hooks/incoming/{hook_id}`
- Summary: Update an incoming webhook
- Description: Update an incoming webhook given the hook id.
##### Permissions
`manage_webhooks` for system or `manage_webhooks` for the specific team or `manage_webhooks` for the channel.

- Tags: webhooks

## Parameters
- `hook_id` (path, required, string) - Incoming Webhook GUID

## Request body
- required: True
- description: Incoming webhook to be updated
- content:
  - `application/json` -> object

## Responses
- `200`: Webhook update successful
  - `application/json` -> IncomingWebhook
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
