# Get first admin onboarding completion status

Original OpenAPI operationId: `GetOnboardingComplete`
- Method: `GET`
- Path: `/api/v4/system/onboarding/complete`
- Summary: Get first admin onboarding completion status
- Description: Get whether first admin onboarding is complete.
##### Permissions Must have `manage_system` permission.

- Tags: system

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Onboarding completion state retrieval successful
  - `application/json` -> System
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
