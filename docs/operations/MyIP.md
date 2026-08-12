# Get all IP filters

Original OpenAPI operationId: `MyIP`
- Method: `GET`
- Path: `/api/v4/ip_filtering/my_ip`
- Summary: Get all IP filters
- Description: Retrieve your current IP address as seen by the workspace
__Minimum server version__: 9.1 __Note:__ This is intended for internal use and only applicable to Cloud workspaces

- Tags: ip, filtering

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: IP address returned successfully
  - `application/json` -> object
- `401`: No description available.
- `500`: No description available.
- `501`: No description available.
