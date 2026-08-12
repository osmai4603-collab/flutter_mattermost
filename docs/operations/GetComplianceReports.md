# Get reports

Original OpenAPI operationId: `GetComplianceReports`
- Method: `GET`
- Path: `/api/v4/compliance/reports`
- Summary: Get reports
- Description: Get a list of compliance reports previously created by page, selected with `page` and `per_page` query parameters.
##### Permissions
Must have `manage_system` permission.

- Tags: compliance

## Parameters
- `page` (query, optional, integer) - The page to select.
- `per_page` (query, optional, integer) - The number of reports per page.

## Request body
No request body.

## Responses
- `200`: Compliance reports retrieval successful
  - `application/json` -> array of Compliance
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
