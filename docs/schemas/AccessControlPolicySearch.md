# AccessControlPolicySearch

Original OpenAPI schema: `AccessControlPolicySearch`

No description available in the official OpenAPI schema.

## Fields

- `term`: string
  - The search term to match against policy names or display names.
- `type`: string
  - The type of policy (e.g., 'parent' or 'channel').
- `parent_id`: string
  - The ID of the parent policy to search within.
- `ids`: array
  - List of policy IDs to filter by.
- `active`: boolean
  - Filter policies by active status.
- `include_children`: boolean
  - Whether to include child policies in the result.
- `cursor`: AccessControlPolicyCursor
- `limit`: integer
  - The maximum number of policies to return.

## Example JSON

```json
{"term": ""string"", "type": ""string"", "parent_id": ""string"", "ids": [], "active": False, "include_children": False, "cursor": "AccessControlPolicyCursor", "limit": 0}
```
