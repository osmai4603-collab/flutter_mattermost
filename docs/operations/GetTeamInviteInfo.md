# Get invite info for a team

Original OpenAPI operationId: `GetTeamInviteInfo`
- Method: `GET`
- Path: `/api/v4/teams/invite/{invite_id}`
- Summary: Get invite info for a team
- Description: Get the `name`, `display_name`, `description` and `id` for a team from the invite id.

__Minimum server version__: 4.0

##### Permissions
No authentication required.

- Tags: teams

## Parameters
- `invite_id` (path, required, string) - Invite id for a team

## Request body
No request body.

## Responses
- `200`: Team invite info retrieval successful
  - `application/json` -> object
- `400`: No description available.
