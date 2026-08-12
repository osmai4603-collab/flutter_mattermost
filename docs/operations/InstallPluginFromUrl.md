# Install plugin from url

Original OpenAPI operationId: `InstallPluginFromUrl`
- Method: `POST`
- Path: `/api/v4/plugins/install_from_url`
- Summary: Install plugin from url
- Description: Supply a URL to a plugin compressed in a .tar.gz file. Plugins must be enabled in the server's config settings.

##### Permissions
Must have `manage_system` permission.

__Minimum server version__: 5.14

- Tags: plugins

## Parameters
- `plugin_download_url` (query, required, string) - URL used to download the plugin
- `force` (query, optional, string) - Set to 'true' to overwrite a previously installed plugin with the same ID, if any

## Request body
No request body.

## Responses
- `201`: Plugin install successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `403`: No description available.
- `501`: No description available.
