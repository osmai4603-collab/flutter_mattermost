# Installs a marketplace plugin

Original OpenAPI operationId: `InstallMarketplacePlugin`
- Method: `POST`
- Path: `/api/v4/plugins/marketplace`
- Summary: Installs a marketplace plugin
- Description: Installs a plugin listed in the marketplace server.

##### Permissions
Must have `manage_system` permission.

__Minimum server version__: 5.16

- Tags: plugins

## Parameters
No parameters.

## Request body
- required: True
- description: The metadata identifying the plugin to install.
- content:
  - `application/json` -> InstallMarketplacePluginRequest

## Responses
- `200`: Plugin installed successfully
  - `application/json` -> PluginManifest
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `501`: No description available.
