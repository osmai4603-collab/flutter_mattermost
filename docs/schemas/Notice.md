# Notice

Original OpenAPI schema: `Notice`

No description available in the official OpenAPI schema.

## Fields

- `id`: string
  - Notice ID
- `sysAdminOnly`: boolean
  - Does this notice apply only to sysadmins
- `teamAdminOnly`: boolean
  - Does this notice apply only to team admins
- `action`: string
  - Optional action to perform on action button click. (defaults to closing the notice)
- `actionParam`: string
  - Optional action parameter. 
Example: {"action": "url", actionParam: "/console/some-page"}
- `actionText`: string
  - Optional override for the action button text (defaults to OK)
- `description`: string
  - Notice content. Use {{Mattermost}} instead of plain text to support white-labeling. Text supports Markdown.
- `image`: string
  - URL of image to display
- `title`: string
  - Notice title. Use {{Mattermost}} instead of plain text to support white-labeling. Text supports Markdown.

## Example JSON

```json
{"id": ""string"", "sysAdminOnly": False, "teamAdminOnly": False, "action": ""string"", "actionParam": ""string"", "actionText": ""string"", "description": ""string"", "image": ""string"", "title": ""string""}
```
