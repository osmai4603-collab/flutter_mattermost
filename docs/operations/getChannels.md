# Get playbook run channels

Original OpenAPI operationId: `getChannels`
- Method: `GET`
- Path: `/plugins/playbooks/api/v0/runs/channels`
- Summary: Get playbook run channels
- Description: Get all channels associated with a playbook run, filtered by team, status, owner, name and/or members, and sorted by ID, name, status, creation date, end date, team, or owner ID.
- Tags: PlaybookRuns
- Security: [{'BearerAuth': []}]

## Parameters
- `team_id` (query, required, string) - ID of the team to filter by.
- `sort` (query, optional, string) - Field to sort the returned channels by, according to their playbook run.
- `direction` (query, optional, string) - Direction (ascending or descending) followed by the sorting of the playbook runs associated to the channels.
- `status` (query, optional, string) - The returned list will contain only the channels whose playbook run has this status.
- `owner_user_id` (query, optional, string) - The returned list will contain only the channels whose playbook run is commanded by this user.
- `search_term` (query, optional, string) - The returned list will contain only the channels associated to a playbook run whose name contains the search term.
- `participant_id` (query, optional, string) - The returned list will contain only the channels associated to a playbook run for which the given user is a participant.

## Request body
No request body.

## Responses
- `200`: Channel IDs.
  - `application/json` -> array of string
- `400`: No description available.
- `403`: No description available.
- `500`: No description available.
