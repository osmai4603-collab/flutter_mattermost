# Invite guests to the team by email

Original OpenAPI operationId: `InviteGuestsToTeam`
- Method: `POST`
- Path: `/api/v4/teams/{team_id}/invite-guests/email`
- Summary: Invite guests to the team by email
- Description: Invite guests to existing team channels usign the user's email.

The number of emails that can be sent is rate limited to 20 per hour with a burst of 20 emails. If the rate limit exceeds, the error message contains details on when to retry and when the timer will be reset.

__Minimum server version__: 5.16

##### Permissions
Must have `invite_guest` permission for the team.

- Tags: teams

## Parameters
- `team_id` (path, required, string) - Team GUID
- `graceful` (query, optional, boolean) - If true, returns an array with both successful invites and errors instead of aborting on first error.
- `guest_magic_link` (query, optional, boolean) - If true, invites guests with magic link (passwordless) authentication. Requires guest magic link feature to be enabled.

## Request body
- required: True
- description: Guests invite information
- content:
  - `application/json` -> object

## Responses
- `200`: Guests invite successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `413`: No description available.
