# Get webapp plugins

Original OpenAPI operationId: `GetWebappPlugins`
- Method: `GET`
- Path: `/api/v4/plugins/webapp`
- Summary: Get webapp plugins
- Description: Get a list of web app plugins installed and activated on the server.

##### Permissions
No permissions required.

__Minimum server version__: 4.4

- Tags: plugins

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Plugin deactivated successfully
  - `application/json` -> array of PluginManifestWebapp
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
