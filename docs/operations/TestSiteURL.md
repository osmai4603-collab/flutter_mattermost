# Checks the validity of a Site URL

Original OpenAPI operationId: `TestSiteURL`
- Method: `POST`
- Path: `/api/v4/site_url/test`
- Summary: Checks the validity of a Site URL
- Description: Sends a Ping request to the mattermost server using the specified Site URL.

##### Permissions
Must have `manage_system` permission.

__Minimum server version__: 5.16

- Tags: system

## Parameters
No parameters.

## Request body
- required: True
- content:
  - `application/json` -> object

## Responses
- `200`: Site URL is valid
  - `application/json` -> StatusOK
- `400`: No description available.
- `403`: No description available.
- `500`: No description available.
