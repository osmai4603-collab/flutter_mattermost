# Count non-compliant personal access tokens

Original OpenAPI operationId: `GetNonCompliantUserAccessTokenCount`
- Method: `GET`
- Path: `/api/v4/users/tokens/non_compliant/count`
- Summary: Count non-compliant personal access tokens
- Description: Count the active personal access tokens that violate the configured `ServiceSettings.MaximumPersonalAccessTokenLifetimeDays` policy (tokens that never expire or expire beyond the cap). Bot account tokens are exempt and never counted. Returns 0 when no maximum lifetime is configured.

__Minimum server version__: 11.1

##### Permissions
Must have `manage_system` permission.

- Tags: users

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Count retrieved successfully
  - `application/json` -> object
- `401`: No description available.
- `403`: No description available.
