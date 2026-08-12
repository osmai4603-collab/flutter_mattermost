# Search files in a team

Original OpenAPI operationId: `SearchFiles`
- Method: `POST`
- Path: `/api/v4/teams/{team_id}/files/search`
- Summary: Search files in a team
- Description: Search for files in a team based on file name, extention and file content (if file content extraction is enabled and supported for the files).
__Minimum server version__: 5.34
##### Permissions
Must be authenticated and have the `view_team` permission.

- Tags: teams, files, search

## Parameters
- `team_id` (path, required, string) - Team GUID

## Request body
- required: True
- description: The search terms and logic to use in the search.
- content:
  - `multipart/form-data` -> object

## Responses
- `200`: Files list retrieval successful
  - `application/json` -> FileInfoList
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
