# Get latest terms of service

Original OpenAPI operationId: `GetTermsOfService`
- Method: `GET`
- Path: `/api/v4/terms_of_service`
- Summary: Get latest terms of service
- Description: Get latest terms of service from the server

__Minimum server version__: 5.4
##### Permissions
Must be authenticated.

- Tags: terms of service

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Terms of service fetched successfully
  - `application/json` -> TermsOfService
- `400`: No description available.
- `401`: No description available.
