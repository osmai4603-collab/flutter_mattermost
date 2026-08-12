# Search access control policies

Original OpenAPI operationId: `SearchAccessControlPolicies`
- Method: `POST`
- Path: `/api/v4/access_control_policies/search`
- Summary: Search access control policies
- Description: Searches for access control policies based on given criteria.
##### Permissions
Must have the `manage_system` permission.

- Tags: access control

## Parameters
No parameters.

## Request body
- required: True
- content:
  - `application/json` -> AccessControlPolicySearch

## Responses
- `200`: Search results for access control policies.
  - `application/json` -> AccessControlPoliciesWithCount
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
