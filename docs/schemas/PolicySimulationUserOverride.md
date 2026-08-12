# PolicySimulationUserOverride

Original OpenAPI schema: `PolicySimulationUserOverride`

Per-user payload for the picker-driven `/cel/simulate_users` endpoint.
The simulator resolves each user's profile attributes from CPA storage
and then layers session context on top: first the requesting admin's
active-session snapshot (when `use_active_session` is true), then the
explicit `session_overrides` map.


## Fields

- `user_id`: string (required)
  - ID of the user to evaluate the draft policy against.
- `use_active_session`: boolean
  - When true, inject the requesting admin's `session.*` attributes
(network_status, device_managed, ip_range, etc.) into this user's
evaluation context. Forward-compatible with future PDP work that
populates session attributes on the request context.

- `session_overrides`: object
  - Replaces individual `session.*` attributes for this user only.
Applied on top of the active-session snapshot when both are set,
so a "configure session" panel can shadow specific values without
discarding the rest of the active session.


## Example JSON

```json
{"user_id": ""string"", "use_active_session": False, "session_overrides": {}}
```
