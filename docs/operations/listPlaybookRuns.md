# List all playbook runs

Original OpenAPI operationId: `listPlaybookRuns`
- Method: `GET`
- Path: `/plugins/playbooks/api/v0/runs`
- Summary: List all playbook runs
- Description: Retrieve a paged list of playbook runs, filtered by team, status, owner, name and/or members, and sorted by ID, name, status, creation date, end date, team or owner ID.
- Tags: PlaybookRuns
- Security: [{'BearerAuth': []}]

## Parameters
- `team_id` (query, required, string) - ID of the team to filter by.
- `page` (query, optional, integer) - Zero-based index of the page to request.
- `per_page` (query, optional, integer) - Number of playbook runs to return per page.
- `sort` (query, optional, string) - Field to sort the returned playbook runs by.
- `direction` (query, optional, string) - Direction (ascending or descending) followed by the sorting of the playbook runs.
- `statuses` (query, optional, array of string) - The returned list will contain only the playbook runs with the specified statuses.
- `owner_user_id` (query, optional, string) - The returned list will contain only the playbook runs commanded by this user. Specify "me" for current user.
- `participant_id` (query, optional, string) - The returned list will contain only the playbook runs for which the given user is a participant. Specify "me" for current user.
- `search_term` (query, optional, string) - The returned list will contain only the playbook runs whose name contains the search term.
- `channel_id` (query, optional, string) - The returned list will contain only the playbook runs associated with this channel ID.
- `omit_ended` (query, optional, boolean) - When set to true, only active runs (with EndAt = 0) are returned. When false or omitted, both active and ended runs are returned.
- `since` (query, optional, integer) - Return only PlaybookRuns created/modified since the given timestamp (in milliseconds).

## Request body
No request body.

## Responses
- `200`: A paged list of playbook runs.
  - `application/json` -> PlaybookRunList
- `400`: No description available.
- `403`: No description available.
- `500`: No description available.
