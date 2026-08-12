# List all connections

Original OpenAPI operationId: `ListOutgoingOAuthConnections`
- Method: `GET`
- Path: `/api/v4/oauth/outgoing_connections`
- Summary: List all connections
- Description: List all outgoing OAuth connections.
__Minimum server version__: 9.6

- Tags: oauth, outgoing_connections, outgoing_oauth_connections

## Parameters
- `team_id` (query, required, string) - Current Team ID in integrations backstage

## Request body
No request body.

## Responses
- `200`: Successfully fetched outgoing OAuth connections
  - `application/json` -> array of OutgoingOAuthConnectionGetItem
- `401`: No description available.
- `500`: No description available.
- `501`: No description available.
