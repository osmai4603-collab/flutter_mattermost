# NewTeamMemberList

Original OpenAPI schema: `NewTeamMembersList`

No description available in the official OpenAPI schema.

## Fields

- `has_next`: boolean
  - Indicates if there is another page of new team members that can be fetched.
- `items`: array
  - List of new team members.
- `total_count`: integer
  - The total count of new team members for the given time range.

## Example JSON

```json
{"has_next": False, "items": [], "total_count": 0}
```

