# Validate business email

Original OpenAPI operationId: `ValidateBusinessEmail`
- Method: `POST`
- Path: `/api/v4/cloud/validate-business-email`
- Summary: Validate business email
- Description: Validate whether an email address is considered a business email by the cloud service.
##### Permissions Must be authenticated.

- Tags: cloud

## Parameters
No parameters.

## Request body
- required: True
- content:
  - `application/json` -> object

## Responses
- `200`: Email validation successful
  - `application/json` -> object
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
