# Get the granular data retention policies

Original OpenAPI operationId: `GetDataRetentionPolicies`
- Method: `GET`
- Path: `/api/v4/data_retention/policies`
- Summary: Get the granular data retention policies
- Description: Gets details about the granular (i.e. team or channel-specific) data retention
policies from the server.

__Minimum server version__: 5.35

##### Permissions
Must have the `sysconsole_read_compliance_data_retention` permission.

##### License
Requires an E20 license.

- Tags: data retention

## Parameters
- `page` (query, optional, integer) - The page to select.
- `per_page` (query, optional, integer) - The number of policies per page.

## Request body
No request body.

## Responses
- `200`: Retention policies' details retrieved successfully.
  - `application/json` -> array of DataRetentionPolicyWithTeamAndChannelCounts
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
- `501`: No description available.
