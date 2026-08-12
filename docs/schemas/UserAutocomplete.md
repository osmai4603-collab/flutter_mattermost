# UserAutocomplete

Original OpenAPI schema: `UserAutocomplete`

No description available in the official OpenAPI schema.

## Fields

- `users`: array
  - A list of users that are the main result of the query
- `out_of_channel`: array
  - A special case list of users returned when autocompleting in a specific channel. Omitted when empty or not relevant

## Example JSON

```json
{"users": [], "out_of_channel": []}
```

