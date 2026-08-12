# Request and install a trial license for your server

Original OpenAPI operationId: `RequestTrialLicense`
- Method: `POST`
- Path: `/api/v4/trial-license`
- Summary: Request and install a trial license for your server
- Description: Request and install a trial license for your server
__Minimum server version__: 5.25
##### Permissions
Must have `manage_system` permission.

- Tags: system

## Parameters
No parameters.

## Request body
- required: True
- description: License request
- content:
  - `application/json` -> object

## Responses
- `200`: Trial license obtained and installed
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
