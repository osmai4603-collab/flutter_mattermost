# ChannelSearch

Original OpenAPI schema: `ChannelSearch`

No description available in the official OpenAPI schema.

## Fields

- `term`: string
  - The string to search in the channel name, display name, and purpose.
- `team_ids`: array
  - Filters results to channels belonging to the given team ids.
- `public`: boolean
  - Filters results to only return Public / Open channels.
- `private`: boolean
  - Filters results to only return Private channels.
- `deleted`: boolean
  - Filters results to only return deleted / archived channels.
- `include_deleted`: boolean
  - Whether to include deleted channels in the search results.

## Example JSON

```json
{"term": ""string"", "team_ids": [], "public": False, "private": False, "deleted": False, "include_deleted": False}
```
