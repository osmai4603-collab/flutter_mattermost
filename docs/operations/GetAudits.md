# Get audits

Original OpenAPI operationId: `GetAudits`
- Method: `GET`
- Path: `/api/v4/audits`
- Summary: Get audits
- Description: Get a page of audits for all users on the system, selected with `page` and `per_page` query parameters.
##### Permissions
Must have `manage_system` permission.

- Tags: system

## Parameters
- `page` (query, optional, integer) - The page to select.
- `per_page` (query, optional, integer) - The number of audits per page.

## Request body
No request body.

## Responses
- `200`: Audits retrieval successful
  - `application/json` -> array of Audit
- `403`: No description available.
