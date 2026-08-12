# OpenGraph

Original OpenAPI schema: `OpenGraph`

OpenGraph metadata of a webpage

## Fields

- `type`: string
- `url`: string
- `title`: string
- `description`: string
- `determiner`: string
- `site_name`: string
- `locale`: string
- `locales_alternate`: array
- `images`: array
- `videos`: array
- `audios`: array
- `article`: object
  - Article object used in OpenGraph metadata of a webpage, if type is article
- `book`: object
  - Book object used in OpenGraph metadata of a webpage, if type is book
- `profile`: object

## Example JSON

```json
{"type": ""string"", "url": ""string"", "title": ""string"", "description": ""string"", "determiner": ""string"", "site_name": ""string"", "locale": ""string"", "locales_alternate": [], "images": [], "videos": [], "audios": [], "article": {}, "book": {}, "profile": {}}
```

