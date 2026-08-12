# PluginStatus

Original OpenAPI schema: `PluginStatus`

No description available in the official OpenAPI schema.

## Fields

- `plugin_id`: string
  - Globally unique identifier that represents the plugin.
- `name`: string
  - Name of the plugin.
- `description`: string
  - Description of what the plugin is and does.
- `version`: string
  - Version number of the plugin.
- `cluster_id`: string
  - ID of the cluster in which plugin is running
- `plugin_path`: string
  - Path to the plugin on the server
- `state`: number
  - State of the plugin

## Example JSON

```json
{"plugin_id": ""string"", "name": ""string"", "description": ""string"", "version": ""string"", "cluster_id": ""string"", "plugin_path": ""string"", "state": 0.0}
```
