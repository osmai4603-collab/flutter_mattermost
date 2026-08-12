# PolicySimulationBlame

Original OpenAPI schema: `PolicySimulationBlame`

Attributes a deny decision back to the rule or policy that caused it.


## Fields

- `source`: string
  - Origin of the blamed contribution.
* `this_rule` — the rule the author is currently editing.
* `sibling_rule` — another rule in the same draft policy.
* `sibling_saved` — recorded on ALLOW decisions where the
  author's own rule alone would have denied; a sibling rule
  flipped the verdict.
* `peer_policy` — a different policy at the SAME scope as the
  draft. Carries `expression` / `evaluation_tree`.
* `system_permission` — a higher-scoped system permission policy.
  Expression / tree are stripped to avoid leaking the contents
  of policies outside the editing scope.
* `channel_policy` — a higher-scoped channel policy. Same
  privacy stripping as `system_permission`.
* `no_applicable_policy` — no policy at any scope contributed a
  decision (vacuous allow).

- `outcome`: string
  - Per-blame verdict. Most blame entries describe the deny that
produced the overall decision (`deny`); the simulator also
emits informational `allow` entries so the picker can show
"your draft rule allowed this user" alongside any peer
policies that actually caused the deny. Consumers that only
care about deny attribution should filter to `deny`. Empty
(omitted) is treated as `deny` for backward compatibility
with simulator builds that pre-date this field.

- `policy_id`: string
  - ID of the contributing policy. Empty when the deny originated
from the draft itself (no persisted ID exists yet).

- `policy_name`: string
  - Human-readable name of the contributing policy.
- `rule_name`: string
  - Name of the contributing rule.
- `role`: string
  - Scoped role (`system_admin` / `system_user` / `channel_admin` /
…) the contributing rule targets. Useful for explaining
role-chain fallbacks.

- `expression`: string
  - CEL text of the contributing rule. Only populated for blame
entries at the draft's own scope (`this_rule`, `sibling_rule`,
`sibling_saved`, `peer_policy`).

- `evaluation_tree`: object
  - Recursive per-node breakdown of the contributing rule, mirroring
the boolean shape of the CEL expression's AST. Same scope-privacy
rule as `expression`. The picker renders it as a structured
AND/OR/NOT tree highlighting which sub-expression(s) drove the
deny.


## Example JSON

```json
{"source": ""string"", "outcome": ""string"", "policy_id": ""string"", "policy_name": ""string"", "rule_name": ""string"", "role": ""string"", "expression": ""string"", "evaluation_tree": {}}
```
