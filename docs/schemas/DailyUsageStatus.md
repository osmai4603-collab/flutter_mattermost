# DailyUsageStatus

Original OpenAPI schema: `DailyUsageStatus`

Daily recap usage tracking

## Fields

- `used`: integer
  - Number of recaps used today
- `limit`: integer
  - Maximum recaps allowed per day
- `reset_at`: integer
  - Unix timestamp in milliseconds when daily usage resets

## Example JSON

```json
{"used": 0, "limit": 0, "reset_at": 0}
```
