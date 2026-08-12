# Regenerate the token for the outgoing webhook.

Original OpenAPI operationId: `RegenOutgoingHookToken`
- Method: `POST`
- Path: `/api/v4/hooks/outgoing/{hook_id}/regen_token`
- Summary: Regenerate the token for the outgoing webhook.
- Description: Regenerate the token for the outgoing webhook.
##### Permissions
`manage_webhooks` for system or `manage_webhooks` for the specific team or `manage_webhooks` for the channel.

- Tags: webhooks

## Parameters
- `hook_id` (path, required, string) - Outgoing webhook GUID

## Request body
No request body.

## Responses
- `200`: Webhook token regenerate successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
