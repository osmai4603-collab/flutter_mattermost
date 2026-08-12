# Creates a new terms of service

Original OpenAPI operationId: `CreateTermsOfService`
- Method: `POST`
- Path: `/api/v4/terms_of_service`
- Summary: Creates a new terms of service
- Description: Creates new terms of service

__Minimum server version__: 5.4
##### Permissions
Must have `manage_system` permission.

- Tags: terms of service

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: terms of service fetched successfully
  - `application/json` -> TermsOfService
- `400`: No description available.
- `401`: No description available.
