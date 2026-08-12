# Get latest public server release information

Original OpenAPI operationId: `GetLatestVersion`
- Method: `GET`
- Path: `/api/v4/latest_version`
- Summary: Get latest public server release information
- Description: Retrieves metadata about the latest Mattermost server release from GitHub.
##### Permissions Must have `manage_system` permission.

- Tags: system

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Latest release metadata retrieval successful
  - `application/json` -> object
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
