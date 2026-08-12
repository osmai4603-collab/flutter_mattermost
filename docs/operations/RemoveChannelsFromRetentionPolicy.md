# Delete channels from a granular data retention policy

Original OpenAPI operationId: `RemoveChannelsFromRetentionPolicy`
- Method: `DELETE`
- Path: `/api/v4/data_retention/policies/{policy_id}/channels`
- Summary: Delete channels from a granular data retention policy
- Description: Delete channels from a granular data retention policy.

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
  - `application/json` -> array of string

## Responses
- `200`: Channels successfully deleted from retention policy.
  - `application/json` -> StatusOK
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
- `501`: No description available.
