# Delete a connection

Original OpenAPI operationId: `DeleteOutgoingOAuthConnection`
- Method: `DELETE`
- Path: `/api/v4/oauth/outgoing_connections/{outgoing_oauth_connection_id}`
- Summary: Delete a connection
- Description: Delete an outgoing OAuth connection.
__Minimum server version__: 9.6

- Tags: oauth, outgoing_connections, outgoing_oauth_connections

## Parameters
- `outgoing_oauth_connection_id` (path, required, string) - Outgoing OAuth connection ID
- `team_id` (query, required, string) - Current Team ID in integrations backstage

## Request body
No request body.

## Responses
- `200`: Successfully deleted outgoing OAuth connection
- `401`: No description available.
- `404`: No description available.
- `500`: No description available.
- `501`: No description available.
