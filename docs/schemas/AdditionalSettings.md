# AdditionalSettings

Original OpenAPI schema: `AdditionalSettings`

No description available in the official OpenAPI schema.

## Fields

- `Reasons`: array (required)
  - Predefined reasons for flagging content
- `ReporterCommentRequired`: boolean (required)
  - Whether a comment is required from the reporter
- `ReviewerCommentRequired`: boolean (required)
  - Whether a comment is required from the reviewer
- `HideFlaggedContent`: boolean (required)
  - Whether to hide flagged content from general view

## Example JSON

```json
{"Reasons": [], "ReporterCommentRequired": False, "ReviewerCommentRequired": False, "HideFlaggedContent": False}
```
