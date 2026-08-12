# AIBridgeTestHelperConfig

Original OpenAPI schema: `AIBridgeTestHelperConfig`

No description available in the official OpenAPI schema.

## Fields

- `status`: AIBridgeTestHelperStatus
- `agents`: array
  - Mock agent list returned from the bridge
- `services`: array
  - Mock service list returned from the bridge
- `agent_completions`: object
  - Queued mocked completion responses keyed by explicit bridge operation name
- `feature_flags`: AIBridgeTestHelperFeatureFlags
- `record_requests`: boolean
  - Whether bridge requests should be recorded for later inspection

## Example JSON

```json
{"status": "AIBridgeTestHelperStatus", "agents": [], "services": [], "agent_completions": {}, "feature_flags": "AIBridgeTestHelperFeatureFlags", "record_requests": False}
```
