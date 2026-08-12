# Get an access control policy

Original OpenAPI operationId: `GetAccessControlPolicy`
- Method: `GET`
- Path: `/api/v4/access_control_policies/{policy_id}`
- Summary: Get an access control policy
- Description: Gets a specific access control policy by its ID.
##### Permissions
Must have the `manage_system` permission.

- Tags: access control

## Parameters
- `policy_id` (path, required, string) - The ID of the access control policy.

## Request body
No request body.

## Responses
- `200`: Access control policy retrieved successfully.
  - `application/json` -> AccessControlPolicy
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `500`: No description available.
