# Update a connection

Original OpenAPI operationId: `UpdateOutgoingOAuthConnection`
- Method: `PUT`
- Path: `/api/v4/oauth/outgoing_connections/{outgoing_oauth_connection_id}`
- Summary: Update a connection
- Description: Update an outgoing OAuth connection.
__Minimum server version__: 9.6

- Tags: oauth, outgoing_connections, outgoing_oauth_connections

## Parameters
- `outgoing_oauth_connection_id` (path, required, string) - Outgoing OAuth connection ID
- `team_id` (query, required, string) - Current Team ID in integrations backstage

## Request body
- required: False
- description: Outgoing OAuth connection to update
- content:
  - `application/json` -> OutgoingOAuthConnectionPostItem

## Responses
- `200`: Successfully updated outgoing OAuth connection
  - `application/json` -> OutgoingOAuthConnectionGetItem
- `400`: No description available.
- `401`: No description available.
- `404`: No description available.
- `500`: No description available.
- `501`: No description available.
