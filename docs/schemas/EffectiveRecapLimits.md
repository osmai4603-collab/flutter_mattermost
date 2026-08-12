# EffectiveRecapLimits

Original OpenAPI schema: `EffectiveRecapLimits`

Resolved recap limit values for a user. A value of -1 means the limit is disabled/unlimited.

## Fields

- `max_recaps_per_day`: integer
  - Maximum number of recaps the user can create per day (-1 = unlimited)
- `max_scheduled_recaps`: integer
  - Maximum number of scheduled recaps (-1 = unlimited)
- `max_channels_per_recap`: integer
  - Maximum number of channels per recap (-1 = unlimited)
- `max_posts_per_recap`: integer
  - Maximum number of posts per recap (-1 = unlimited)
- `max_tokens_per_recap`: integer
  - Maximum number of tokens per recap (-1 = unlimited)
- `max_posts_per_day`: integer
  - Maximum number of posts that can be processed per day (-1 = unlimited)
- `cooldown_minutes`: integer
  - Cooldown period in minutes between recap creations (-1 = no cooldown)
- `source`: string
  - Where the effective limits originated from
- `source_id`: string
  - Group ID or User ID if overridden, empty for system defaults

## Example JSON

```json
{"max_recaps_per_day": 0, "max_scheduled_recaps": 0, "max_channels_per_recap": 0, "max_posts_per_recap": 0, "max_tokens_per_recap": 0, "max_posts_per_day": 0, "cooldown_minutes": 0, "source": ""string"", "source_id": ""string""}
```
