# QueryExpressionParams

Original OpenAPI schema: `QueryExpressionParams`

No description available in the official OpenAPI schema.

## Fields

- `expression`: string
  - The policy expression to test.
- `term`: string
  - A search term to filter users against whom the expression is tested.
- `limit`: integer
  - The maximum number of users to return.
- `after`: string
  - The ID of the user to start the test after (for pagination).
- `channelId`: string
  - The channel ID to contextually test the expression against (required for channel admins).

## Example JSON

```json
{"expression": ""string"", "term": ""string"", "limit": 0, "after": ""string"", "channelId": ""string""}
```
