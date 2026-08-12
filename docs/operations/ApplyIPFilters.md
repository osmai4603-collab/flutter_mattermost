# Get all IP filters

Original OpenAPI operationId: `ApplyIPFilters`
- Method: `POST`
- Path: `/api/v4/ip_filtering`
- Summary: Get all IP filters
- Description: Adjust IP Filters applied to the workspace
__Minimum server version__: 9.1 __Note:__ This is intended for internal use and only applicable to Cloud workspaces

- Tags: ip, filtering

## Parameters
No parameters.

## Request body
- required: True
- description: IP Filters to apply
- content:
  - `application/json` -> array of AllowedIPRange

## Responses
- `200`: IP Filters returned successfully
  - `application/json` -> array of AllowedIPRange
- `401`: No description available.
- `500`: No description available.
- `501`: No description available.
