# Patch configuration

Original OpenAPI operationId: `PatchConfig`
- Method: `PUT`
- Path: `/api/v4/config/patch`
- Summary: Patch configuration
- Description: Submit configuration to patch. As of server version 4.8, the `PluginSettings.EnableUploads` and `PluginSettings.SignaturePublicKeyFiles` settings cannot be modified by this endpoint.
##### Permissions
Must have `manage_system` permission.
__Minimum server version__: 5.20
##### Note
The Plugins are stored as a map, and since a map may recursively go  down to any depth, individual fields of a map are not changed.  Consider using the `update config` (PUT api/v4/config) endpoint to update a plugins configurations.

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
