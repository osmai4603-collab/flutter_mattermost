# Create a new job.

Original OpenAPI operationId: `CreateJob`
- Method: `POST`
- Path: `/api/v4/jobs`
- Summary: Create a new job.
- Description: Create a new job.
__Minimum server version: 4.1__
##### Permissions
Must have permission to create the requested job type. Required permission depends on `type`:

- `create_data_retention_job` — `data_retention`
- `create_compliance_export_job` — `message_export`
- `create_elasticsearch_post_indexing_job` — `elasticsearch_post_indexing`
- `create_elasticsearch_post_aggregation_job` — `elasticsearch_post_aggregation`
- `create_ldap_sync_job` — `ldap_sync`
- `manage_jobs` — `migrations`, `plugins`, `product_notices`, `expiry_notify`, `active_users`, `import_process`, `import_delete`, `export_process`, `export_delete`, `cloud`, `extract_content`
- `access_control_sync` — `manage_system`, or `manage_channel_access_rules` on the channel given in job `data`, or `manage_team_access_rules` on the team in job `data` (see server logic for scoped sync jobs)

- Tags: jobs

## Parameters
No parameters.

## Request body
- required: True
- description: Job object to be created
- content:
  - `application/json` -> object

## Responses
- `201`: Job creation successful
  - `application/json` -> Job
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
