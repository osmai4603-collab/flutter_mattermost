# Get the list of followers' user IDs of a playbook

Original OpenAPI operationId: `getAutoFollows`
- Method: `GET`
- Path: `/plugins/playbooks/api/v0/playbooks/{id}/autofollows`
- Summary: Get the list of followers' user IDs of a playbook
- Tags: PlaybookAutofollows
- Security: [{'BearerAuth': []}]

## Parameters
- `id` (path, required, string) - ID of the playbook to retrieve followers from.

## Request body
No request body.

## Responses
- `200`: List of the user IDs who follow the playbook.
  - `application/json` -> PlaybookAutofollows
- `403`: No description available.
- `500`: No description available.
