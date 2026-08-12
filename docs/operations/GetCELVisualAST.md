# Get the visual AST for a CEL expression

Original OpenAPI operationId: `GetCELVisualAST`
- Method: `POST`
- Path: `/api/v4/access_control_policies/cel/visual_ast`
- Summary: Get the visual AST for a CEL expression
- Description: Retrieves the visual AST for a CEL expression.
##### Permissions
Must have the `manage_system` permission.

- Tags: access control

## Parameters
No parameters.

## Request body
- required: True
- content:
  - `application/json` -> CELExpression

## Responses
- `200`: Visual AST retrieved successfully.
  - `application/json` -> VisualExpression
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
