# ConditionList

Original OpenAPI schema: `ConditionList`

No description available in the official OpenAPI schema.

## Fields

- `total_count`: integer
  - The total number of conditions in the list, regardless of paging.
- `page_count`: integer
  - The total number of pages. This depends on the total number of conditions and the per_page parameter.
- `has_more`: boolean
  - A boolean describing whether there are more pages after the currently returned.
- `items`: array
  - The conditions in this page.

## Example JSON

```json
{"total_count": 0, "page_count": 0, "has_more": False, "items": []}
```
