# Get the jobs of the given type.

Original OpenAPI operationId: `GetJobsByType`
- Method: `GET`
- Path: `/api/v4/jobs/type/{job_type}`
- Summary: Get the jobs of the given type.
- Description: Get a page of jobs of the given type. Use the query parameters to modify
the behaviour of this endpoint.

__Minimum server version: 4.1__

##### Permissions
Must have permission to read the path `job_type`, using the same mapping as `GET /api/v4/jobs`:

- `read_data_retention_job` — `data_retention`
- `read_compliance_export_job` — `message_export`
- `read_elasticsearch_post_indexing_job` — `elasticsearch_post_indexing`
- `read_elasticsearch_post_aggregation_job` — `elasticsearch_post_aggregation`
- `read_ldap_sync_job` — `ldap_sync`
- `read_jobs` — `migrations`, `plugins`, `product_notices`, `expiry_notify`, `active_users`, `import_process`, `import_delete`, `export_process`, `export_delete`, `cloud`, `mobile_session_metadata`, `extract_content`
- `manage_system` — `access_control_sync`

When `job_type` is `access_control_sync` and query parameter `team_id` is set to a valid team GUID, team admins with `manage_team_access_rules` on that team may list jobs scoped to that team without `manage_system`. When `team_id` is set, results include only jobs whose stored data matches that team for the requested type.

- Tags: jobs

## Parameters
- `job_type` (path, required, string) - Job type
- `team_id` (query, optional, string) - Optional team GUID. When set, the server returns jobs of the given `job_type` whose job data includes this `team_id` (see server filtering). For `access_control_sync`, team admins with `manage_team_access_rules` on this team may use this parameter to read team-scoped jobs without `manage_system`.

- `page` (query, optional, integer) - The page to select.
- `per_page` (query, optional, integer) - The number of jobs per page.

## Request body
No request body.

## Responses
- `200`: Job list retrieval successful
  - `application/json` -> array of Job
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
