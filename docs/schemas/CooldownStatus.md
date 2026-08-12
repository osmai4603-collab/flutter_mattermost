# CooldownStatus

Original OpenAPI schema: `CooldownStatus`

Cooldown state for recap creation

## Fields

- `is_active`: boolean
  - Whether the cooldown is currently active
- `available_at`: integer
  - Unix timestamp in milliseconds when cooldown ends
- `retry_after_seconds`: integer
  - Seconds until recap creation is available again

## Example JSON

```json
{"is_active": False, "available_at": 0, "retry_after_seconds": 0}
```
