# Delete a granular data retention policy

Original OpenAPI operationId: `DeleteDataRetentionPolicy`
- Method: `DELETE`
- Path: `/api/v4/data_retention/policies/{policy_id}`
- Summary: Delete a granular data retention policy
- Description: Deletes a granular data retention policy.

__Minimum server version__: 5.35

##### Permissions
Must have the `sysconsole_write_compliance_data_retention` permission.

##### License
Requires an E20 license.

- Tags: data retention

## Parameters
- `policy_id` (path, required, string) - The ID of the granular retention policy.

## Request body
No request body.

## Responses
- `200`: Retention policy successfully deleted.
  - `application/json` -> StatusOK
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
- `501`: No description available.
