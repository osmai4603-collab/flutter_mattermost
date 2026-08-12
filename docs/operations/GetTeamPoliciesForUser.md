# Get the policies which are applied to a user's teams

Original OpenAPI operationId: `GetTeamPoliciesForUser`
- Method: `GET`
- Path: `/api/v4/users/{user_id}/data_retention/team_policies`
- Summary: Get the policies which are applied to a user's teams
- Description: Gets the policies which are applied to the all of the teams to which a user belongs.

__Minimum server version__: 5.35

##### Permissions
Must be logged in as the user or have the `manage_system` permission.

##### License
Requires an E20 license.

- Tags: data retention

## Parameters
- `user_id` (path, required, string) - The ID of the user. This can also be "me" which will point to the current user.
- `page` (query, optional, integer) - The page to select.
- `per_page` (query, optional, integer) - The number of policies per page.

## Request body
No request body.

## Responses
- `200`: Teams for retention policy successfully retrieved.
  - `application/json` -> RetentionPolicyForTeamList
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
- `501`: No description available.
