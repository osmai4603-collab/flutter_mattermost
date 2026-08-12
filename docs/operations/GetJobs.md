# Get the jobs.

Original OpenAPI operationId: `GetJobs`
- Method: `GET`
- Path: `/api/v4/jobs`
- Summary: Get the jobs.
- Description: Get a page of jobs. Use the query parameters to modify the behaviour of
this endpoint.

__Minimum server version: 4.1__

##### Permissions
Must have permission to read at least one job type returned by this call.
When no `job_type` query parameter is set, the server only includes job types your session may read; required permission depends on the job type:

- `read_data_retention_job` — `data_retention`
- `read_compliance_export_job` — `message_export`
- `read_elasticsearch_post_indexing_job` — `elasticsearch_post_indexing`
- `read_elasticsearch_post_aggregation_job` — `elasticsearch_post_aggregation`
- `read_ldap_sync_job` — `ldap_sync`
- `read_jobs` — `migrations`, `plugins`, `product_notices`, `expiry_notify`, `active_users`, `import_process`, `import_delete`, `export_process`, `export_delete`, `cloud`, `mobile_session_metadata`, `extract_content`
- `manage_system` — `access_control_sync`

When `job_type` is set, you must have the permission that matches that type (same mapping as above).

This endpoint does not accept `team_id`. To list `access_control_sync` jobs scoped to a team without `manage_system`, use `GET /api/v4/jobs/type/access_control_sync` with query parameter `team_id` set to the team GUID (requires `manage_team_access_rules` on that team).

- Tags: jobs

## Parameters
- `page` (query, optional, integer) - The page to select.
- `per_page` (query, optional, integer) - The number of jobs per page.
- `job_type` (query, optional, string) - The type of jobs to fetch.
- `status` (query, optional, string) - The status of jobs to fetch.

## Request body
No request body.

## Responses
- `200`: Job list retrieval successful
  - `application/json` -> array of Job
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
