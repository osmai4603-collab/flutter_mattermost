# PolicySimulationUserResult

Original OpenAPI schema: `PolicySimulationUserResult`

No description available in the official OpenAPI schema.

## Fields

- `user`: User
- `decisions`: object
  - Per-action verdicts for the user. When `sessions` is populated
this represents the "headline" decision (e.g. from the
most-recently-active session) so the picker can render a
single chip without consulting `sessions`.

- `sessions`: array
  - Optional per-session breakdown. When populated the picker
renders a Recent activity expand row revealing one decision
chip per session. Empty/undefined falls back to a single
user-level chip.

- `attributes`: object
  - User profile attribute snapshot used when evaluating this user
(department, region, clearance, etc.).


## Example JSON

```json
{"user": "User", "decisions": {}, "sessions": [], "attributes": {}}
```
