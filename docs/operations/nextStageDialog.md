# Go to next stage from dialog

Original OpenAPI operationId: `nextStageDialog`
- Method: `POST`
- Path: `/plugins/playbooks/api/v0/runs/{id}/next-stage-dialog`
- Summary: Go to next stage from dialog
- Description: This is an internal endpoint to go to the next stage via a confirmation dialog, submitted by a user in the webapp.
- Tags: Internal
- Security: [{'BearerAuth': []}]

## Parameters
- `id` (path, required, string) - The PlaybookRun ID

## Request body
- required: False
- description: Dialog submission payload.
- content:
  - `application/json` -> object

## Responses
- `200`: Playbook run stage update.
- `400`: No description available.
- `500`: No description available.
