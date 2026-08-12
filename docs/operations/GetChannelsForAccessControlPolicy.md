# Get channels for an access control policy

Original OpenAPI operationId: `GetChannelsForAccessControlPolicy`
- Method: `GET`
- Path: `/api/v4/access_control_policies/{policy_id}/resources/channels`
- Summary: Get channels for an access control policy
- Description: Retrieves a paginated list of channels to which a specific access control policy is applied.
##### Permissions
Must have the `manage_system` permission.

- Tags: access control

## Parameters
- `policy_id` (path, required, string) - The ID of the access control policy.
- `after` (query, optional, string) - The channel ID to start after for pagination.
- `limit` (query, required, integer) - The maximum number of channels to return.

## Request body
No request body.

## Responses
- `200`: Channels retrieved successfully.
  - `application/json` -> ChannelsWithCount
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `500`: No description available.
