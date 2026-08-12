# Get a granular data retention policy

Original OpenAPI operationId: `GetDataRetentionPolicyByID`
- Method: `GET`
- Path: `/api/v4/data_retention/policies/{policy_id}`
- Summary: Get a granular data retention policy
- Description: Gets details about a granular data retention policies by ID.

__Minimum server version__: 5.35

##### Permissions
Must have the `sysconsole_read_compliance_data_retention` permission.

##### License
Requires an E20 license.

- Tags: data retention

## Parameters
- `policy_id` (path, required, string) - The ID of the granular retention policy.

## Request body
No request body.

## Responses
- `200`: Retention policy's details retrieved successfully.
  - `application/json` -> DataRetentionPolicyWithTeamAndChannelCounts
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
- `501`: No description available.
