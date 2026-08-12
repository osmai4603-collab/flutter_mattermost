# Complete first admin onboarding

Original OpenAPI operationId: `CompleteOnboarding`
- Method: `POST`
- Path: `/api/v4/system/onboarding/complete`
- Summary: Complete first admin onboarding
- Description: Mark first admin onboarding as complete and optionally trigger plugin installation.
##### Permissions Must have `manage_system` permission.

- Tags: system

## Parameters
No parameters.

## Request body
- required: True
- content:
  - `application/json` -> object

## Responses
- `200`: Onboarding completion successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
