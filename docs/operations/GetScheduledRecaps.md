# Get current user's scheduled recaps

Original OpenAPI operationId: `GetScheduledRecaps`
- Method: `GET`
- Path: `/api/v4/scheduled_recaps`
- Summary: Get current user's scheduled recaps
- Description: Get a paginated list of scheduled recaps for the authenticated user.
##### Permissions
Must be authenticated.
__Minimum server version__: 11.2

- Tags: scheduled recaps, ai

## Parameters
- `page` (query, optional, integer) - The page to select.
- `per_page` (query, optional, integer) - The number of scheduled recaps per page.

## Request body
No request body.

## Responses
- `200`: Scheduled recaps retrieval successful
  - `application/json` -> array of ScheduledRecap
- `400`: No description available.
- `401`: No description available.
- `501`: No description available.
