# PolicySimulationResponse

Original OpenAPI schema: `PolicySimulationResponse`

Body returned by `/cel/simulate_users`. Per-user, per-action
verdicts plus blame attribution for any deny.


## Fields

- `results`: array
- `total`: integer
  - Total number of users evaluated (matches `results.length` for
the picker endpoint since the caller supplies the user list
explicitly).


## Example JSON

```json
{"results": [], "total": 0}
```
