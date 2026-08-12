# Get recommended public channels for the current user

Original OpenAPI operationId: `GetRecommendedChannelsForTeam`
- Method: `GET`
- Path: `/api/v4/teams/{team_id}/channels/recommended`
- Summary: Get recommended public channels for the current user
- Description: Return the public channels on a team that have a membership policy
assigned, where the requesting user's attributes match to the policy.

Membership policies on public channels are advisory: anyone can still join
these channels. This endpoint surfaces them as "Recommended channels"
for the requester.

Returns an empty list if the Enterprise Advanced license is not
active, if `AccessControlSettings.EnableAttributeBasedAccessControl`
is `false`, or if the user's attributes do not match any active
public-channel policy in the team.

__Minimum server version__: 11.8

##### Permissions
Must be authenticated and have `list_team_channels` on the team.

- Tags: channels

## Parameters
- `team_id` (path, required, string) - Team GUID

## Request body
No request body.

## Responses
- `200`: Recommended channels retrieval successful
  - `application/json` -> array of Channel
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
