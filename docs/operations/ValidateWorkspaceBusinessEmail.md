# Validate workspace business email

Original OpenAPI operationId: `ValidateWorkspaceBusinessEmail`
- Method: `POST`
- Path: `/api/v4/cloud/validate-workspace-business-email`
- Summary: Validate workspace business email
- Description: Validate the current workspace customer/admin email as a business email.
##### Permissions Must have `sysconsole_write_billing` permission and be licensed for Cloud.

- Tags: cloud

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Workspace email validation successful
  - `application/json` -> object
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
