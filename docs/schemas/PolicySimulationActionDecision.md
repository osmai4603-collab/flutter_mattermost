# PolicySimulationActionDecision

Original OpenAPI schema: `PolicySimulationActionDecision`

Per-action verdict for one user (or one session).

## Fields

- `decision`: boolean
  - `true` means ALLOW, `false` means DENY. Pending evaluations
(rare) surface as `false` paired with an empty `blame` array.

- `blame`: array
  - Ordered blame entries for the decision. The first entry is the
primary blame (what the picker renders on the chip); subsequent
entries describe other contributing policies the user can drill
into via the "Decision details" view.


## Example JSON

```json
{"decision": False, "blame": []}
```
