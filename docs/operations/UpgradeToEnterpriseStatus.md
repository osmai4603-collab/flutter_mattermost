# Get the current status for the inplace upgrade from Team Edition to Enterprise Edition

Original OpenAPI operationId: `UpgradeToEnterpriseStatus`
- Method: `GET`
- Path: `/api/v4/upgrade_to_enterprise/status`
- Summary: Get the current status for the inplace upgrade from Team Edition to Enterprise Edition
- Description: It returns the percentage of completion of the current upgrade or the error if there is any.
__Minimum server version__: 5.27
##### Permissions
Must have `manage_system` permission.

- Tags: system

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Upgrade status
  - `application/json` -> object
- `403`: No description available.
