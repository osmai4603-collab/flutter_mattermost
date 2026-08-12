# Get autocomplete data for /playbook check

Original OpenAPI operationId: `getChecklistAutocomplete`
- Method: `GET`
- Path: `/plugins/playbooks/api/v0/runs/checklist-autocomplete`
- Summary: Get autocomplete data for /playbook check
- Description: This is an internal endpoint used by the autocomplete system to retrieve the data needed to show the list of items that the user can check.
- Tags: Internal
- Security: [{'BearerAuth': []}]

## Parameters
- `channel_ID` (query, required, string) - ID of the channel the user is in.

## Request body
No request body.

## Responses
- `200`: List of autocomplete items for this channel.
  - `application/json` -> array of object
- `500`: No description available.
