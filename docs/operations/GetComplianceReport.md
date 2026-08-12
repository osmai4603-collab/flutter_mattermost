# Get a report

Original OpenAPI operationId: `GetComplianceReport`
- Method: `GET`
- Path: `/api/v4/compliance/reports/{report_id}`
- Summary: Get a report
- Description: Get a compliance reports previously created.
##### Permissions
Must have `manage_system` permission.

- Tags: compliance

## Parameters
- `report_id` (path, required, string) - Compliance report GUID

## Request body
No request body.

## Responses
- `200`: Compliance report retrieval successful
  - `application/json` -> Compliance
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
