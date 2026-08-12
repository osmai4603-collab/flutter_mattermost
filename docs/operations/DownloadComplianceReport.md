# Download a report

Original OpenAPI operationId: `DownloadComplianceReport`
- Method: `GET`
- Path: `/api/v4/compliance/reports/{report_id}/download`
- Summary: Download a report
- Description: Download the full contents of a report as a file.
##### Permissions
Must have `manage_system` permission.

- Tags: compliance

## Parameters
- `report_id` (path, required, string) - Compliance report GUID

## Request body
No request body.

## Responses
- `200`: The compliance report file
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
