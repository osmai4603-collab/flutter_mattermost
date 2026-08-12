# PluginManifest

Original OpenAPI schema: `PluginManifest`

No description available in the official OpenAPI schema.

## Fields

- `id`: string
  - Globally unique identifier that represents the plugin.
- `name`: string
  - Name of the plugin.
- `description`: string
  - Description of what the plugin is and does.
- `version`: string
  - Version number of the plugin.
- `min_server_version`: string
  - The minimum Mattermost server version required for the plugin.

Available as server version 5.6.

- `backend`: object
  - Deprecated in Mattermost 5.2 release.
- `server`: object
- `webapp`: object
- `settings_schema`: object
  - Settings schema used to define the System Console UI for the plugin.

## Example JSON

```json
{"id": ""string"", "name": ""string"", "description": ""string"", "version": ""string"", "min_server_version": ""string"", "backend": {}, "server": {}, "webapp": {}, "settings_schema": {}}
```
