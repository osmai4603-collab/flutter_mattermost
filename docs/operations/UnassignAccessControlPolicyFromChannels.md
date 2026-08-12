# Unassign an access control policy from channels or teams

Original OpenAPI operationId: `UnassignAccessControlPolicyFromChannels`
- Method: `DELETE`
- Path: `/api/v4/access_control_policies/{policy_id}/unassign`
- Summary: Unassign an access control policy from channels or teams
- Description: Unassigns an access control policy from a list of channels and/or teams.
##### Permissions
Must have the `manage_system` permission.

- Tags: access control

## Parameters
- `policy_id` (path, required, string) - The ID of the access control policy.

## Request body
- required: True
- content:
  - `application/json` -> object

## Responses
- `200`: Policy unassigned from the channels and/or teams successfully.
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `500`: No description available.
