# Get a list of remote clusters.

Original OpenAPI operationId: `GetRemoteClusters`
- Method: `GET`
- Path: `/api/v4/remotecluster`
- Summary: Get a list of remote clusters.
- Description: Get a list of remote clusters.

##### Permissions
`manage_secure_connections` or `manage_shared_channels`

- Tags: remote clusters

## Parameters
- `page` (query, optional, integer) - The page to select
- `per_page` (query, optional, integer) - The number of remote clusters per page
- `exclude_offline` (query, optional, boolean) - Exclude offline remote clusters
- `in_channel` (query, optional, string) - Select remote clusters in channel
- `not_in_channel` (query, optional, string) - Select remote clusters not in this channel
- `only_confirmed` (query, optional, boolean) - Select only remote clusters already confirmed
- `only_plugins` (query, optional, boolean) - Select only remote clusters that belong to a plugin
- `exclude_plugins` (query, optional, boolean) - Select only remote clusters that don't belong to a plugin
- `include_deleted` (query, optional, boolean) - Include those remote clusters that have been deleted

## Request body
No request body.

## Responses
- `200`: Remote clusters fetch successful. Result might be empty.
  - `application/json` -> array of RemoteCluster
- `401`: No description available.
- `403`: No description available.
