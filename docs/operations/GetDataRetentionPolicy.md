# Get the global data retention policy

Original OpenAPI operationId: `GetDataRetentionPolicy`
- Method: `GET`
- Path: `/api/v4/data_retention/policy`
- Summary: Get the global data retention policy
- Description: Gets the current global data retention policy details from the server,
including what data should be purged and the cutoff times for each data
type that should be purged.

__Minimum server version__: 4.3

##### Permissions
Requires an active session but no other permissions.

##### License
Requires an E20 license.

- Tags: data retention

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Global data retention policy details retrieved successfully.
  - `application/json` -> GlobalDataRetentionPolicy
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
- `501`: No description available.
