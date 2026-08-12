# Get managed category mappings

Original OpenAPI operationId: `GetManagedCategories`
- Method: `GET`
- Path: `/api/v4/teams/{team_id}/channels/managed_categories`
- Summary: Get managed category mappings
- Description: Returns a map of channel ID to managed category name for all channels the requesting user is a member of in the given team that have a managed category assigned.

Requires an Enterprise license and the `ManagedChannelCategories` feature flag to be enabled.

##### Permissions
Must be authenticated.

- Tags: channels

## Parameters
- `team_id` (path, required, string) - Team ID

## Request body
No request body.

## Responses
- `200`: Managed category mappings retrieved successfully
  - `application/json` -> object
- `401`: No description available.
- `404`: Returned when the `ManagedChannelCategories` feature flag is disabled.
- `501`: Returned when the server does not have an Enterprise license.
