# Get license load metric

Original OpenAPI operationId: `GetLicenseLoadMetric`
- Method: `GET`
- Path: `/api/v4/license/load_metric`
- Summary: Get license load metric
- Description: Get the current license load metric, calculated based on monthly active users against the licensed user count. Returns a value of 0 when there is no license loaded or the license doesn't have a user count.
__Minimum server version__: 10.8
##### Permissions
Must be logged in.

- Tags: system

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: License load metric retrieval successful
  - `application/json` -> object
- `401`: No description available.
- `500`: No description available.
