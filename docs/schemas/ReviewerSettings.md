# ReviewerSettings

Original OpenAPI schema: `ReviewerSettings`

No description available in the official OpenAPI schema.

## Fields

- `CommonReviewers`: boolean (required)
  - Whether to use common reviewers across all teams
- `SystemAdminsAsReviewers`: boolean (required)
  - Whether system administrators can act as reviewers
- `TeamAdminsAsReviewers`: boolean (required)
  - Whether team administrators can act as reviewers
- `CommonReviewerIds`: array (required)
  - List of user IDs designated as common reviewers
- `TeamReviewersSetting`: object (required)
  - Team-specific reviewer configuration, keyed by team ID

## Example JSON

```json
{"CommonReviewers": False, "SystemAdminsAsReviewers": False, "TeamAdminsAsReviewers": False, "CommonReviewerIds": [], "TeamReviewersSetting": {}}
```
