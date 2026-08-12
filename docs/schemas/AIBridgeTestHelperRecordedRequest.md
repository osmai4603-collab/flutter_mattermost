# AIBridgeTestHelperRecordedRequest

Original OpenAPI schema: `AIBridgeTestHelperRecordedRequest`

No description available in the official OpenAPI schema.

## Fields

- `operation`: string
  - Explicit bridge operation key such as recap_summary or rewrite
- `client_operation`: string
  - Client-facing operation routed through the bridge client
- `operation_sub_type`: string
  - Optional subtype used to disambiguate bridge requests
- `session_user_id`: string
  - Session user ID used when invoking the bridge
- `user_id`: string
  - Optional effective user ID passed through the bridge request
- `channel_id`: string
  - Optional channel context passed through the bridge request
- `agent_id`: string
  - Agent ID targeted by the bridge completion request
- `service_id`: string
  - Service ID targeted by the bridge completion request
- `messages`: array
  - Bridge messages sent for the recorded request
- `json_output_format`: object
  - Optional JSON schema requested for structured bridge output

## Example JSON

```json
{"operation": ""string"", "client_operation": ""string"", "operation_sub_type": ""string"", "session_user_id": ""string"", "user_id": ""string"", "channel_id": ""string"", "agent_id": ""string"", "service_id": ""string"", "messages": [], "json_output_format": {}}
```
