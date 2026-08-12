# Delete an incoming webhook

Original OpenAPI operationId: `DeleteIncomingWebhook`
- Method: `DELETE`
- Path: `/api/v4/hooks/incoming/{hook_id}`
- Summary: Delete an incoming webhook
- Description: Delete an incoming webhook given the hook id.
##### Permissions
`manage_webhooks` for system or `manage_webhooks` for the specific team or `manage_webhooks` for the channel.

- Tags: webhooks

## Parameters
- `hook_id` (path, required, string) - Incoming webhook GUID

## Request body
No request body.

## Responses
- `200`: Webhook deletion successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
