# ScheduledRecap

Original OpenAPI schema: `ScheduledRecap`

No description available in the official OpenAPI schema.

## Fields

- `id`: string
  - Unique identifier for the scheduled recap
- `user_id`: string
  - The ID of the user who owns this scheduled recap
- `title`: string
  - Title for the scheduled recap
- `days_of_week`: integer
  - Bitmask for days of the week the recap should run. Sun=1, Mon=2, Tue=4, Wed=8, Thu=16, Fri=32, Sat=64.

- `time_of_day`: string
  - Time of day in HH:MM format (e.g., "09:00")
- `timezone`: string
  - IANA timezone (e.g., "America/New_York")
- `time_period`: string
  - The lookback period for the recap content
- `next_run_at`: integer
  - The next scheduled execution time in UTC milliseconds
- `last_run_at`: integer
  - The last execution time in UTC milliseconds
- `run_count`: integer
  - Number of times this schedule has executed
- `channel_mode`: string
  - How channels are selected for the recap
- `channel_ids`: array
  - List of channel IDs to include (when channel_mode is "specific")
- `custom_instructions`: string
  - Custom AI instructions for the recap
- `agent_id`: string
  - ID of the AI agent to use for generating the recap
- `is_recurring`: boolean
  - Whether the recap runs on a recurring schedule or just once
- `enabled`: boolean
  - Whether the scheduled recap is active (false when paused)
- `create_at`: integer
  - The time in milliseconds the scheduled recap was created
- `update_at`: integer
  - The time in milliseconds the scheduled recap was last updated
- `delete_at`: integer
  - The time in milliseconds the scheduled recap was soft-deleted (0 if not deleted)

## Example JSON

```json
{"id": ""string"", "user_id": ""string"", "title": ""string"", "days_of_week": 0, "time_of_day": ""string"", "timezone": ""string"", "time_period": ""string"", "next_run_at": 0, "last_run_at": 0, "run_count": 0, "channel_mode": ""string"", "channel_ids": [], "custom_instructions": ""string"", "agent_id": ""string"", "is_recurring": False, "enabled": False, "create_at": 0, "update_at": 0, "delete_at": 0}
```
