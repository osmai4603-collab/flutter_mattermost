# Search channels for an access control policy

Original OpenAPI operationId: `SearchChannelsForAccessControlPolicy`
- Method: `POST`
- Path: `/api/v4/access_control_policies/{policy_id}/resources/channels/search`
- Summary: Search channels for an access control policy
- Description: Searches for channels associated with a specific access control policy based on search criteria.
##### Permissions
Must have the `manage_system` permission.

- Tags: access control

## Parameters
- `policy_id` (path, required, string) - The ID of the access control policy.

## Request body
- required: True
- content:
  - `application/json` -> ChannelSearch

## Responses
- `200`: Channel search results retrieved successfully.
  - `application/json` -> ChannelsWithCount
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `500`: No description available.
