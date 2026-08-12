# Get property values for a playbook run

Original OpenAPI operationId: `getRunPropertyValues`
- Method: `GET`
- Path: `/plugins/playbooks/api/v0/runs/{id}/property_values`
- Summary: Get property values for a playbook run
- Tags: PlaybookRuns
- Security: [{'BearerAuth': []}]

## Parameters
- `id` (path, required, string) - ID of the playbook run to retrieve property values from.
- `updated_since` (query, optional, integer) - Filter results to only include property values updated after this timestamp (Unix time in milliseconds).

## Request body
No request body.

## Responses
- `200`: List of property values for the playbook run.
  - `application/json` -> array of PropertyValue
- `400`: No description available.
- `403`: No description available.
- `500`: No description available.
