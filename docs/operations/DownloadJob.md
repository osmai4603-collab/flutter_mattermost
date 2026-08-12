# Download the results of a job.

Original OpenAPI operationId: `DownloadJob`
- Method: `GET`
- Path: `/api/v4/jobs/{job_id}/download`
- Summary: Download the results of a job.
- Description: Download the result of a single job.
__Minimum server version: 5.28__
##### Permissions
Must have `download_compliance_export_result` permission for message export jobs.

- Tags: jobs

## Parameters
- `job_id` (path, required, string) - Job GUID

## Request body
No request body.

## Responses
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
