# Assign an access control policy to channels or teams

Original OpenAPI operationId: `AssignAccessControlPolicyToChannels`
- Method: `POST`
- Path: `/api/v4/access_control_policies/{policy_id}/assign`
- Summary: Assign an access control policy to channels or teams
- Description: Assigns an access control policy to a list of channels and/or teams.
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
- `200`: Policy assigned to the channels and/or teams successfully.
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `500`: No description available.
