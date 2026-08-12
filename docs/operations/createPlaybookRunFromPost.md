# Create a new playbook run

Original OpenAPI operationId: `createPlaybookRunFromPost`
- Method: `POST`
- Path: `/plugins/playbooks/api/v0/runs`
- Summary: Create a new playbook run
- Description: Create a new playbook run in a team, using a playbook as template, with a specific name and a specific owner.
- Tags: PlaybookRuns
- Security: [{'BearerAuth': []}]

## Parameters
No parameters.

## Request body
- required: False
- description: Playbook run payload.
- content:
  - `application/json` -> object

## Responses
- `201`: Created playbook run.
  - `application/json` -> PlaybookRun
- `400`: No description available.
- `403`: No description available.
- `500`: No description available.
