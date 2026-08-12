# Get shared channel remotes by remote cluster.

Original OpenAPI operationId: `GetSharedChannelRemotesByRemoteCluster`
- Method: `GET`
- Path: `/api/v4/remotecluster/{remote_id}/sharedchannelremotes`
- Summary: Get shared channel remotes by remote cluster.
- Description: Get a list of the channels shared with a given remote cluster
and their status.

##### Permissions
`manage_secure_connections` or `manage_shared_channels`

- Tags: shared channels

## Parameters
- `remote_id` (path, required, string) - The remote cluster GUID
- `include_unconfirmed` (query, optional, boolean) - Include those Shared channel remotes that are unconfirmed
- `exclude_confirmed` (query, optional, boolean) - Show only those Shared channel remotes that are not confirmed yet
- `exclude_home` (query, optional, boolean) - Show only those Shared channel remotes that were shared with this server
- `exclude_remote` (query, optional, boolean) - Show only those Shared channel remotes that were shared from this server
- `include_deleted` (query, optional, boolean) - Include those Shared channel remotes that have been deleted
- `page` (query, optional, integer) - The page to select
- `per_page` (query, optional, integer) - The number of shared channels per page

## Request body
No request body.

## Responses
- `200`: Shared channel remotes fetch successful. Result might be empty.
  - `application/json` -> array of SharedChannelRemote
- `401`: No description available.
- `403`: No description available.
