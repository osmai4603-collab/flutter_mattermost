# Retrieve a list of supported timezones

Original OpenAPI operationId: `GetSupportedTimezone`
- Method: `GET`
- Path: `/api/v4/system/timezones`
- Summary: Retrieve a list of supported timezones
- Description: __Minimum server version__: 3.10
##### Permissions
Must be logged in.

- Tags: system

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: List of timezones retrieval successful
  - `application/json` -> array of string
- `500`: No description available.
