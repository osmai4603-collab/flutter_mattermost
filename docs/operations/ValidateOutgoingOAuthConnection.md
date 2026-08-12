# Validate a connection configuration

Original OpenAPI operationId: `ValidateOutgoingOAuthConnection`
- Method: `POST`
- Path: `/api/v4/oauth/outgoing_connections/validate`
- Summary: Validate a connection configuration
- Description: Validate an outgoing OAuth connection. If an id is provided in the payload, and no client secret is provided, then the stored client secret is implicitly used for the validation.
__Minimum server version__: 9.6

- Tags: oauth, outgoing_connections, outgoing_oauth_connections

## Parameters
- `team_id` (query, required, string) - Current Team ID in integrations backstage

## Request body
- required: False
- description: Outgoing OAuth connection to validate
- content:
  - `application/json` -> OutgoingOAuthConnectionPostItem

## Responses
- `200`: The connection configuration is valid.
- `400`: The connection configuration is invalid.
- `401`: No description available.
- `404`: No description available.
- `500`: No description available.
- `501`: No description available.
- `502`: The connection configuration may be valid, but the server is unable to validate it upstream.
