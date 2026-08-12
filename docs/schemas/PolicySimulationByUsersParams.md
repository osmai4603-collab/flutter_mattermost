# PolicySimulationByUsersParams

Original OpenAPI schema: `PolicySimulationByUsersParams`

Request body for `/access_control_policies/cel/simulate_users`. The
draft policy is compiled in-memory only — nothing is persisted.


## Fields

- `policy`: AccessControlPolicy (required)
- `actions`: array (required)
  - Permission actions to simulate (e.g. `upload_file_attachment`,
`download_file_attachment`). At least one action is required —
the picker UX only makes sense once an action is in scope. The
backend rejects empty arrays with `app.pap.simulate.missing_actions`
(HTTP 400); `minItems` lets OpenAPI tooling catch that earlier
on the client.

- `rule_name`: string
  - Identifies which rule in `policy.rules` the author is editing
(used for blame attribution). When set, denies originating from
this rule are tagged `source=this_rule`; other denies in the same
draft are tagged `source=sibling_rule`.

- `channel_id`: string
  - Provides resource context for delegated channel admins and for
resource-lane evaluation when `policy.type == "channel"`.

- `team_id`: string
  - Provides team context for team-level delegated admins.
- `users`: array (required)
  - Explicit user list to evaluate, with per-user session-attribute
overrides. At least one user is required (the backend rejects
empty arrays with `app.pap.simulate.missing_users`).

- `evaluation_scope`: string
  - Selects whether the simulator considers only the rule under
simulation (`this_rule`) or co-evaluates every contributing
program (`all`). Empty defaults to `this_rule` on the server.
`this_rule` is the authoring-time "what does this rule alone
do?" view: useful for iterating on a single rule without
sibling rules shadowing or compensating for it. `all` mirrors
the live PDP at request time.


## Example JSON

```json
{"policy": "AccessControlPolicy", "actions": [], "rule_name": ""string"", "channel_id": ""string"", "team_id": ""string"", "users": [], "evaluation_scope": ""string""}
```
