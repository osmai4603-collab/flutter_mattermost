# Activate or deactivate access control policies

Original OpenAPI operationId: `UpdateAccessControlPoliciesActive`
- Method: `PUT`
- Path: `/api/v4/access_control_policies/activate`
- Summary: Activate or deactivate access control policies
- Description: Updates the active status of access control policies.

##### Permissions
Must have the `manage_system` permission. OR be a channel admin with manage_channel_access_rules permission for the specified channels.

- Tags: access control

## Parameters
No parameters.

## Request body
- required: True
- content:
  - `application/json` -> AccessControlPolicyActiveUpdateRequest

## Responses
- `200`: Access control policies active status updated successfully.
  - `application/json` -> AccessControlPolicy
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
- `501`: No description available.
