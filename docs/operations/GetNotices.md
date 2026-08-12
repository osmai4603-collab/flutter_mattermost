# Get notices for logged in user in specified team

Original OpenAPI operationId: `GetNotices`
- Method: `GET`
- Path: `/api/v4/system/notices/{team_id}`
- Summary: Get notices for logged in user in specified team
- Description: Will return appropriate product notices for current user in the team specified by team_id parameter.
__Minimum server version__: 5.26
##### Permissions
Must be logged in.

- Tags: system

## Parameters
- `clientVersion` (query, required, string) - Version of the client (desktop/mobile/web) that issues the request
- `locale` (query, optional, string) - Client locale
- `client` (query, required, string) - Client type (web/mobile-ios/mobile-android/desktop)
- `team_id` (path, required, string) - ID of the team

## Request body
No request body.

## Responses
- `200`: List notices retrieve successful
  - `application/json` -> array of Notice
- `500`: No description available.
