# Create a new granular data retention policy

Original OpenAPI operationId: `CreateDataRetentionPolicy`
- Method: `POST`
- Path: `/api/v4/data_retention/policies`
- Summary: Create a new granular data retention policy
- Description: Creates a new granular data retention policy with the specified display
name and post duration.

__Minimum server version__: 5.35

##### Permissions
Must have the `sysconsole_write_compliance_data_retention` permission.

##### License
Requires an E20 license.

- Tags: data retention

## Parameters
No parameters.

## Request body
- required: True
- content:
  - `application/json` -> DataRetentionPolicyCreate

## Responses
- `201`: Retention policy successfully created.
  - `application/json` -> DataRetentionPolicyWithTeamAndChannelCounts
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
- `501`: No description available.
