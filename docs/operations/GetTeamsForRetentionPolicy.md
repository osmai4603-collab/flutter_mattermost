# Get the teams for a granular data retention policy

Original OpenAPI operationId: `GetTeamsForRetentionPolicy`
- Method: `GET`
- Path: `/api/v4/data_retention/policies/{policy_id}/teams`
- Summary: Get the teams for a granular data retention policy
- Description: Gets the teams to which a granular data retention policy is applied.

__Minimum server version__: 5.35

##### Permissions
Must have the `sysconsole_read_compliance_data_retention` permission.

##### License
Requires an E20 license.

- Tags: data retention

## Parameters
- `policy_id` (path, required, string) - The ID of the granular retention policy.
- `page` (query, optional, integer) - The page to select.
- `per_page` (query, optional, integer) - The number of teams per page.

## Request body
No request body.

## Responses
- `200`: Teams for retention policy successfully retrieved.
  - `application/json` -> array of Team
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
- `501`: No description available.
