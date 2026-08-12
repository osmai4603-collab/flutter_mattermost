# Get user's audits

Original OpenAPI operationId: `GetUserAudits`
- Method: `GET`
- Path: `/api/v4/users/{user_id}/audits`
- Summary: Get user's audits
- Description: Get a list of audit by providing the user GUID.
##### Permissions
Must be logged in as the user or have the `edit_other_users` permission.

- Tags: users

## Parameters
- `user_id` (path, required, string) - User GUID

## Request body
No request body.

## Responses
- `200`: User audits retrieval successful
  - `application/json` -> array of Audit
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
