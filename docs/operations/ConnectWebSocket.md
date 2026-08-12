# Open a WebSocket connection

Original OpenAPI operationId: `ConnectWebSocket`
- Method: `GET`
- Path: `/api/v4/websocket`
- Summary: Open a WebSocket connection
- Description: Upgrades the HTTP connection to a WebSocket connection used for real-time events and websocket actions.

##### Permissions
No permission required to connect. Authentication can be performed via standard API auth (cookie/header)
or by sending an `authentication_challenge` action after connecting.

- Tags: system

## Parameters
- `connection_id` (query, optional, string) - Existing connection identifier for reconnect flows.
- `sequence_number` (query, optional, string) - Last received sequence number for reconnect flows.
- `posted_ack` (query, optional, boolean) - Whether post acknowledgement events are enabled for this connection.
- `disconnect_err_code` (query, optional, string) - Optional close code used by clients to indicate disconnect reason.

## Request body
No request body.

## Responses
- `101`: Switching Protocols
- `400`: No description available.
