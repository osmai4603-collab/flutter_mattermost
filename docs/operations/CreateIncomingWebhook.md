# Create an incoming webhook

Original OpenAPI operationId: `CreateIncomingWebhook`
- Method: `POST`
- Path: `/api/v4/hooks/incoming`
- Summary: Create an incoming webhook
- Description: Create an incoming webhook for a channel.
##### Permissions
`manage_webhooks` for the team the webhook is in.

`manage_others_incoming_webhooks` for the team the webhook is in if the user is different than the requester.

- Tags: webhooks

## Parameters
No parameters.

## Request body
- required: True
- description: Incoming webhook to be created
- content:
  - `application/json` -> object

## Responses
- `201`: Incoming webhook creation successful
  - `application/json` -> IncomingWebhook
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
