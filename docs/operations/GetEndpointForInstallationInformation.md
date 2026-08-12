# GET endpoint for Installation information

Original OpenAPI operationId: `GetEndpointForInstallationInformation`
- Method: `GET`
- Path: `/api/v4/cloud/installation`
- Summary: GET endpoint for Installation information
- Description: An endpoint for fetching the installation information.
##### Permissions
Must have `sysconsole_read_site_ip_filters` permission and be licensed for Cloud.
__Minimum server version__: 9.1 __Note:__ This is intended for internal use and is subject to change.

- Tags: cloud

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Installation returned successfully
  - `application/json` -> Installation
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
