# Download system logs

Original OpenAPI operationId: `DownloadSystemLogs`
- Method: `GET`
- Path: `/api/v4/logs/download`
- Summary: Download system logs
- Description: Downloads the system logs as a text file.

- Tags: logs

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: System logs downloaded successfully.
  - `text/plain` -> string
- `500`: No description available.
