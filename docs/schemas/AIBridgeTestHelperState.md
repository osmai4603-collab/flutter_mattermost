# AIBridgeTestHelperState

Original OpenAPI schema: `AIBridgeTestHelperState`

No description available in the official OpenAPI schema.

## Fields

- `status`: AIBridgeTestHelperStatus
- `agents`: array
  - Current mocked agent list
- `services`: array
  - Current mocked service list
- `agent_completions`: object
  - Remaining queued mocked completions keyed by bridge operation
- `feature_flags`: AIBridgeTestHelperFeatureFlags
- `record_requests`: boolean
  - Whether bridge request recording is currently enabled
- `recorded_requests`: array
  - Recorded bridge requests captured while record_requests was enabled

## Example JSON

```json
{"status": "AIBridgeTestHelperStatus", "agents": [], "services": [], "agent_completions": {}, "feature_flags": "AIBridgeTestHelperFeatureFlags", "record_requests": False, "recorded_requests": []}
```
