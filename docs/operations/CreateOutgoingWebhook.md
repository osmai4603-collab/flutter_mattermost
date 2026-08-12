# Create an outgoing webhook

Original OpenAPI operationId: `CreateOutgoingWebhook`
- Method: `POST`
- Path: `/api/v4/hooks/outgoing`
- Summary: Create an outgoing webhook
- Description: Create an outgoing webhook for a team.
##### Permissions
`manage_webhooks` for the team the webhook is in.

`manage_others_outgoing_webhooks` for the team the webhook is in if the user is different than the requester.

- Tags: webhooks

## Parameters
No parameters.

## Request body
- required: True
- description: Outgoing webhook to be created
- content:
  - `application/json` -> object

## Responses
- `201`: Outgoing webhook creation successful
  - `application/json` -> OutgoingWebhook
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
