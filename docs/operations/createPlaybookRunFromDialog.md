# Create a new playbook run from dialog

Original OpenAPI operationId: `createPlaybookRunFromDialog`
- Method: `POST`
- Path: `/plugins/playbooks/api/v0/runs/dialog`
- Summary: Create a new playbook run from dialog
- Description: This is an internal endpoint to create a playbook run from the submission of an interactive dialog, filled by a user in the webapp. See [Interactive Dialogs](https://docs.mattermost.com/developer/interactive-dialogs.html) for more information.
- Tags: Internal
- Security: [{'BearerAuth': []}]

## Parameters
No parameters.

## Request body
- required: False
- description: Dialog submission payload.
- content:
  - `application/json` -> object

## Responses
- `201`: Created playbook run.
  - `application/json` -> PlaybookRun
- `400`: No description available.
- `403`: No description available.
- `500`: No description available.
