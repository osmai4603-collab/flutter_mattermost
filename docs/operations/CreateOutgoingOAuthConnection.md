# Create a connection

Original OpenAPI operationId: `CreateOutgoingOAuthConnection`
- Method: `POST`
- Path: `/api/v4/oauth/outgoing_connections`
- Summary: Create a connection
- Description: Create an outgoing OAuth connection.
__Minimum server version__: 9.6

- Tags: oauth, outgoing_connections, outgoing_oauth_connections

## Parameters
- `team_id` (query, required, string) - Current Team ID in integrations backstage

## Request body
- required: False
- description: Outgoing OAuth connection to create
- content:
  - `application/json` -> OutgoingOAuthConnectionPostItem

## Responses
- `201`: Successfully created outgoing OAuth connection
  - `application/json` -> OutgoingOAuthConnectionGetItem
- `400`: No description available.
- `401`: No description available.
- `500`: No description available.
- `501`: No description available.
