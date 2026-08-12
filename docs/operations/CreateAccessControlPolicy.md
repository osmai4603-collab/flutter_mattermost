# Create an access control policy

Original OpenAPI operationId: `CreateAccessControlPolicy`
- Method: `PUT`
- Path: `/api/v4/access_control_policies`
- Summary: Create an access control policy
- Description: Creates a new access control policy.
##### Permissions
Must have the `manage_system` permission.

- Tags: access control

## Parameters
No parameters.

## Request body
- required: True
- content:
  - `application/json` -> AccessControlPolicy

## Responses
- `200`: Access control policy created successfully.
  - `application/json` -> AccessControlPolicy
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
