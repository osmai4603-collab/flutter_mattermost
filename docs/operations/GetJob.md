# Get a job.

Original OpenAPI operationId: `GetJob`
- Method: `GET`
- Path: `/api/v4/jobs/{job_id}`
- Summary: Get a job.
- Description: Gets a single job.
__Minimum server version: 4.1__
##### Permissions
Must have permission to read the job's type:

- `read_data_retention_job` — `data_retention`
- `read_compliance_export_job` — `message_export`
- `read_elasticsearch_post_indexing_job` — `elasticsearch_post_indexing`
- `read_elasticsearch_post_aggregation_job` — `elasticsearch_post_aggregation`
- `read_ldap_sync_job` — `ldap_sync`
- `read_jobs` — `migrations`, `plugins`, `product_notices`, `expiry_notify`, `active_users`, `import_process`, `import_delete`, `export_process`, `export_delete`, `cloud`, `mobile_session_metadata`, `extract_content`
- `manage_system` — `access_control_sync`

- Tags: jobs

## Parameters
- `job_id` (path, required, string) - Job GUID

## Request body
No request body.

## Responses
- `200`: Job retrieval successful
  - `application/json` -> Job
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
