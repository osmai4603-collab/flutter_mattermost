# Patch a granular data retention policy

Original OpenAPI operationId: `PatchDataRetentionPolicy`
- Method: `PATCH`
- Path: `/api/v4/data_retention/policies/{policy_id}`
- Summary: Patch a granular data retention policy
- Description: Patches (i.e. replaces the fields of) a granular data retention policy.
If any fields are omitted, they will not be changed.

__Minimum server version__: 5.35

##### Permissions
Must have the `sysconsole_write_compliance_data_retention` permission.

##### License
Requires an E20 license.

- Tags: data retention

## Parameters
- `policy_id` (path, required, string) - The ID of the granular retention policy.

## Request body
- required: True
- content:
  - `application/json` -> DataRetentionPolicyWithTeamAndChannelIds

## Responses
- `200`: Retention policy successfully patched.
  - `application/json` -> DataRetentionPolicyWithTeamAndChannelCounts
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
- `501`: No description available.
