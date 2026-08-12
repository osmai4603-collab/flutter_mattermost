# Gets all the marketplace plugins

Original OpenAPI operationId: `GetMarketplacePlugins`
- Method: `GET`
- Path: `/api/v4/plugins/marketplace`
- Summary: Gets all the marketplace plugins
- Description: Gets all plugins from the marketplace server, merging data from locally installed plugins as well as prepackaged plugins shipped with the server.

##### Permissions
Must have `manage_system` permission.

__Minimum server version__: 5.16

- Tags: plugins

## Parameters
- `page` (query, optional, integer) - Page number to be fetched. (not yet implemented)
- `per_page` (query, optional, integer) - Number of item per page. (not yet implemented)
- `filter` (query, optional, string) - Set to filter plugins by ID, name, or description.
- `server_version` (query, optional, string) - Set to filter minimum plugin server version. (not yet implemented)
- `local_only` (query, optional, boolean) - Set true to only retrieve local plugins.

## Request body
No request body.

## Responses
- `200`: Plugins retrieval successful
  - `application/json` -> array of MarketplacePlugin
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
