# Remove a timeline event from the playbook run

Original OpenAPI operationId: `removeTimelineEvent`
- Method: `DELETE`
- Path: `/plugins/playbooks/api/v0/runs/{id}/timeline/{event_id}`
- Summary: Remove a timeline event from the playbook run
- Tags: Timeline
- Security: [{'BearerAuth': []}]

## Parameters
- `id` (path, required, string) - ID of the playbook run whose timeline event will be modified.
- `event_id` (path, required, string) - ID of the timeline event to be deleted

## Request body
No request body.

## Responses
- `204`: Item successfully deleted.
- `400`: No description available.
- `500`: No description available.
