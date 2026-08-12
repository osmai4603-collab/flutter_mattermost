# Check an access control policy expression

Original OpenAPI operationId: `CheckAccessControlPolicyExpression`
- Method: `POST`
- Path: `/api/v4/access_control_policies/cel/check`
- Summary: Check an access control policy expression
- Description: Checks the syntax and validity of an access control policy expression.
##### Permissions
Must have the `manage_system` permission.

- Tags: access control

## Parameters
No parameters.

## Request body
- required: True
- content:
  - `application/json` -> object

## Responses
- `200`: Expression check result.
  - `application/json` -> array of ExpressionError
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
