# Get recap limit status for the current user

Original OpenAPI operationId: `GetRecapLimitStatus`
- Method: `GET`
- Path: `/api/v4/recaps/limit_status`
- Summary: Get recap limit status for the current user
- Description: Get the current user's recap usage limits and status, including daily usage, effective limits, and cooldown information.
##### Permissions
Must be authenticated.
__Minimum server version__: 11.2

- Tags: recaps, ai

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Recap limit status retrieval successful
  - `application/json` -> RecapLimitStatus
- `401`: No description available.
- `501`: Recaps feature is not enabled
