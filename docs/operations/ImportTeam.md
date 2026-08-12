# Import a Team from other application

Original OpenAPI operationId: `ImportTeam`
- Method: `POST`
- Path: `/api/v4/teams/{team_id}/import`
- Summary: Import a Team from other application
- Description: Import a team into a existing team. Import users, channels, posts, hooks.
##### Permissions
Must have `permission_import_team` permission.

- Tags: teams

## Parameters
- `team_id` (path, required, string) - Team GUID

## Request body
- required: False
- content:
  - `multipart/form-data` -> object

## Responses
- `200`: JSON object containing a base64 encoded text file of the import logs in its `results` property.
  - `application/json` -> object
- `400`: No description available.
- `403`: No description available.
