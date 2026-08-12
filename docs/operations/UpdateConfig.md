# Update configuration

Original OpenAPI operationId: `UpdateConfig`
- Method: `PUT`
- Path: `/api/v4/config`
- Summary: Update configuration
- Description: Submit a new configuration for the server to use. As of server version 4.8, the `PluginSettings.EnableUploads` and `PluginSettings.SignaturePublicKeyFiles` settings cannot be modified by this endpoint.
Note that the parameters that aren't set in the configuration that you provide will be reset to default values. Therefore, if you want to change a configuration parameter and leave the other ones unchanged, you need to get the existing configuration first, change the field that you want, then put that new configuration.
##### Permissions
Must have `manage_system` permission.

- Tags: system

## Parameters
No parameters.

## Request body
- required: True
- description: Mattermost configuration
- content:
  - `application/json` -> Config

## Responses
- `200`: Configuration update successful
  - `application/json` -> Config
- `400`: No description available.
- `403`: No description available.
