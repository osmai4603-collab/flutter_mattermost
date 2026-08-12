# Activate or deactivate an access control policy

Original OpenAPI operationId: `UpdateAccessControlPolicyActiveStatus`
- Method: `GET`
- Path: `/api/v4/access_control_policies/{policy_id}/activate`
- Summary: Activate or deactivate an access control policy
- Description: Updates the active status of an access control policy.

**Deprecated:** This endpoint will be removed in a future release. Use the dedicated access control policy update endpoint instead.
Link: </api/v4/access_control_policies/activate>; rel="successor-version"

##### Permissions
Must have the `manage_system` permission.

- Tags: access control
- Deprecated: True

## Parameters
- `policy_id` (path, required, string) - The ID of the access control policy.
- `active` (query, required, boolean) - Set to "true" to activate, "false" to deactivate.

## Request body
No request body.

## Responses
- `200`: Policy active status updated successfully.
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `500`: No description available.
