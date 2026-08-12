# Invite users to the team by email

Original OpenAPI operationId: `InviteUsersToTeam`
- Method: `POST`
- Path: `/api/v4/teams/{team_id}/invite/email`
- Summary: Invite users to the team by email
- Description: Invite users to the existing team using the user's email.

The number of emails that can be sent is rate limited to 20 per hour with a burst of 20 emails. If the rate limit exceeds, the error message contains details on when to retry and when the timer will be reset.
##### Permissions
Must have `invite_user` and `add_user_to_team` permissions for the team.

- Tags: teams

## Parameters
- `team_id` (path, required, string) - Team GUID
- `graceful` (query, optional, boolean) - When provided with a non-empty value, returns an array with both successful invites and errors instead of aborting on the first error. Required when using `profiles`.

## Request body
- required: True
- description: List of user's email, or an object with emails and invitation options
- content:
  - `application/json` -> object

## Responses
- `200`: Users invite successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `413`: No description available.
