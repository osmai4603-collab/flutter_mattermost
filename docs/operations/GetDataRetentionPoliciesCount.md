# Get the number of granular data retention policies

Original OpenAPI operationId: `GetDataRetentionPoliciesCount`
- Method: `GET`
- Path: `/api/v4/data_retention/policies_count`
- Summary: Get the number of granular data retention policies
- Description: Gets the number of granular (i.e. team or channel-specific) data retention
policies from the server.

__Minimum server version__: 5.35

##### Permissions
Must have the `sysconsole_read_compliance_data_retention` permission.

##### License
Requires an E20 license.

- Tags: data retention

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Number of retention policies retrieved successfully.
  - `application/json` -> object
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
- `501`: No description available.
