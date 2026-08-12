# Validate if the current user matches a CEL expression

Original OpenAPI operationId: `ValidateExpressionAgainstRequester`
- Method: `POST`
- Path: `/api/v4/access_control_policies/cel/validate_requester`
- Summary: Validate if the current user matches a CEL expression
- Description: Validates whether the current authenticated user matches the given CEL expression.
This is used to determine if a channel admin can test expressions they match.
##### Permissions
Must have `manage_system` permission OR be a channel admin for the specified channel (channelId required for channel admins).

- Tags: access control

## Parameters
No parameters.

## Request body
- required: True
- content:
  - `application/json` -> object

## Responses
- `200`: Validation result returned successfully.
  - `application/json` -> object
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
