# Find playbook run by channel ID

Original OpenAPI operationId: `getPlaybookRunByChannelId`
- Method: `GET`
- Path: `/plugins/playbooks/api/v0/runs/channel/{channel_id}`
- Summary: Find playbook run by channel ID
- Tags: PlaybookRuns
- Security: [{'BearerAuth': []}]

## Parameters
- `channel_id` (path, required, string) - ID of the channel associated to the playbook run to retrieve.

## Request body
No request body.

## Responses
- `200`: Playbook run associated to the channel.
  - `application/json` -> PlaybookRun
- `404`: No description available.
- `500`: No description available.
