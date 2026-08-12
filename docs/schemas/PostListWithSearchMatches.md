# PostListWithSearchMatches

Original OpenAPI schema: `PostListWithSearchMatches`

No description available in the official OpenAPI schema.

## Fields

- `order`: array
- `posts`: object
- `matches`: object
  - A mapping of post IDs to a list of matched terms within the post. This field will only be populated on servers running version 5.1 or greater with Elasticsearch enabled.

## Example JSON

```json
{"order": [], "posts": {}, "matches": {}}
```

