# Fetches user's latest terms of service action if the latest action was for acceptance.

Original OpenAPI operationId: `GetUserTermsOfService`
- Method: `GET`
- Path: `/api/v4/users/{user_id}/terms_of_service`
- Summary: Fetches user's latest terms of service action if the latest action was for acceptance.
- Description: Will be deprecated in v6.0
Fetches user's latest terms of service action if the latest action was for acceptance.

__Minimum server version__: 5.6
##### Permissions
Must be logged in as the user being acted on.

- Tags: users, terms of service

## Parameters
- `user_id` (path, required, string) - User GUID

## Request body
No request body.

## Responses
- `200`: User's accepted terms of service action
  - `application/json` -> UserTermsOfService
- `400`: No description available.
- `401`: No description available.
- `404`: User hasn't performed an action or the latest action was a rejection.
  - `application/json` -> AppError
