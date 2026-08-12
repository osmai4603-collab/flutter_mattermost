# Starts a job to export the users to a report file.

Original OpenAPI operationId: `StartBatchUsersExport`
- Method: `POST`
- Path: `/api/v4/reports/users/export`
- Summary: Starts a job to export the users to a report file.
- Description: Starts a job to export the users to a report file.
##### Permissions
Requires `sysconsole_read_user_management_users`.

- Tags: reports

## Parameters
- `date_range` (query, optional, string) - The date range of the post statistics to display. Must be one of ("last30days", "previousmonth", "last6months", "alltime"). Will default to 'alltime' if the input is not valid.

## Request body
No request body.

## Responses
- `200`: Job successfully started
  - `application/json` -> array of UserReport
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
