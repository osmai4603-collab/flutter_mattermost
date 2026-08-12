# PostList

Original OpenAPI schema: `PostList`

No description available in the official OpenAPI schema.

## Fields

- `order`: array
- `posts`: object
- `next_post_id`: string
  - The ID of next post. Not omitted when empty or not relevant.
- `prev_post_id`: string
  - The ID of previous post. Not omitted when empty or not relevant.
- `has_next`: boolean
  - Whether there are more items after this page.

## Example JSON

```json
{"order": [], "posts": {}, "next_post_id": ""string"", "prev_post_id": ""string"", "has_next": False}
```

