# Test an access control policy expression

Original OpenAPI operationId: `TestAccessControlPolicyExpression`
- Method: `POST`
- Path: `/api/v4/access_control_policies/cel/test`
- Summary: Test an access control policy expression
- Description: Tests an access control policy expression against users to see who would be affected.
##### Permissions
Must have the `manage_system` permission.

- Tags: access control

## Parameters
No parameters.

## Request body
- required: True
- content:
  - `application/json` -> QueryExpressionParams

## Responses
- `200`: Expression test result.
  - `application/json` -> AccessControlPolicyTestResponse
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
