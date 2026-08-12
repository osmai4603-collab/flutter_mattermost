# Check CWS connection

Original OpenAPI operationId: `CheckCWSConnection`
- Method: `GET`
- Path: `/api/v4/cloud/check-cws-connection`
- Summary: Check CWS connection
- Description: Checks whether the Customer Web Server (CWS) is reachable from this instance. Used to detect if the deployment is air-gapped.
##### Permissions
No permissions required.
__Minimum server version__: 5.28 __Note:__ This is intended for internal use and is subject to change.

- Tags: cloud

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: CWS connection status returned successfully
  - `application/json` -> object
