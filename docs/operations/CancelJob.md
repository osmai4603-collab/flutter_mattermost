# Cancel a job.

Original OpenAPI operationId: `CancelJob`
- Method: `POST`
- Path: `/api/v4/jobs/{job_id}/cancel`
- Summary: Cancel a job.
- Description: Cancel a job.
__Minimum server version: 4.1__
##### Permissions
Same as creating that job type (cancel uses the create permission check):

- `create_data_retention_job` — `data_retention`
- `create_compliance_export_job` — `message_export`
- `create_elasticsearch_post_indexing_job` — `elasticsearch_post_indexing`
- `create_elasticsearch_post_aggregation_job` — `elasticsearch_post_aggregation`
- `create_ldap_sync_job` — `ldap_sync`
- `manage_jobs` — `migrations`, `plugins`, `product_notices`, `expiry_notify`, `active_users`, `import_process`, `import_delete`, `export_process`, `export_delete`, `cloud`, `extract_content`
- `access_control_sync` — `manage_system`, or `manage_channel_access_rules` / `manage_team_access_rules` for scoped jobs as when creating

- Tags: jobs

## Parameters
- `job_id` (path, required, string) - Job GUID

## Request body
No request body.

## Responses
- `200`: Job canceled successfully
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
