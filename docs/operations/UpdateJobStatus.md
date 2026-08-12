# Update the status of a job

Original OpenAPI operationId: `UpdateJobStatus`
- Method: `PATCH`
- Path: `/api/v4/jobs/{job_id}/status`
- Summary: Update the status of a job
- Description: Update the status of a job. Valid status updates:
- 'in_progress' -> 'pending'
- 'in_progress' | 'pending' -> 'cancel_requested'
- 'cancel_requested' -> 'canceled'

Add force to the body of the PATCH request to bypass the given rules, the only statuses you can go to are: pending, cancel_requested and canceled. This can have unexpected consequences and should be used with caution.

##### Permissions
Must have permission to manage the job's type:

- `manage_data_retention_job` — `data_retention`
- `manage_compliance_export_job` — `message_export`
- `manage_elasticsearch_post_indexing_job` — `elasticsearch_post_indexing`
- `manage_elasticsearch_post_aggregation_job` — `elasticsearch_post_aggregation`
- `manage_ldap_sync_job` — `ldap_sync`
- `manage_jobs` — `migrations`, `plugins`, `product_notices`, `expiry_notify`, `active_users`, `import_process`, `import_delete`, `export_process`, `export_delete`, `cloud`, `extract_content`
- `manage_system` — `access_control_sync`

- Tags: jobs

## Parameters
- `job_id` (path, required, string) - Job GUID

## Request body
- required: True
- content:
  - `application/json` -> object

## Responses
- `200`: Status successfully set.
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
