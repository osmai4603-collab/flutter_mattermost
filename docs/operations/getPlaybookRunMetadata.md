# Get playbook run metadata

Original OpenAPI operationId: `getPlaybookRunMetadata`
- Method: `GET`
- Path: `/plugins/playbooks/api/v0/runs/{id}/metadata`
- Summary: Get playbook run metadata
- Tags: PlaybookRuns
- Security: [{'BearerAuth': []}]

## Parameters
- `id` (path, required, string) - ID of the playbook run whose metadata will be retrieved.

## Request body
No request body.

## Responses
- `200`: Playbook run metadata.
  - `application/json` -> PlaybookRunMetadata
- `403`: No description available.
- `500`: No description available.
