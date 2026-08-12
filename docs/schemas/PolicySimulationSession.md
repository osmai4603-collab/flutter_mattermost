# PolicySimulationSession

Original OpenAPI schema: `PolicySimulationSession`

Per-session verdict for one user.

## Fields

- `device`: string
- `network`: string
- `last_active_at`: integer
  - Last-active timestamp in milliseconds since epoch.
- `decisions`: object
  - Per-action verdicts for this specific session.
- `attributes`: object
  - Session-attribute snapshot used when evaluating this session
(network_status, device_managed, ip_range, etc.). Surfaced in
the per-row "Decision details" view.


## Example JSON

```json
{"device": ""string"", "network": ""string"", "last_active_at": 0, "decisions": {}, "attributes": {}}
```
