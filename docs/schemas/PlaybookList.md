# PlaybookList

Original OpenAPI schema: `PlaybookList`

No description available in the official OpenAPI schema.

## Fields

- `total_count`: integer
  - The total number of playbooks in the list, regardless of the paging.
- `page_count`: integer
  - The total number of pages. This depends on the total number of playbooks in the database and the per_page parameter sent with the request.
- `has_more`: boolean
  - A boolean describing whether there are more pages after the currently returned.
- `items`: array
  - The playbooks in this page.

## Example JSON

```json
{"total_count": 0, "page_count": 0, "has_more": False, "items": []}
```
