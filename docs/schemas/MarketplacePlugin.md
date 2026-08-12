# MarketplacePlugin

Original OpenAPI schema: `MarketplacePlugin`

No description available in the official OpenAPI schema.

## Fields

- `homepage_url`: string
  - URL that leads to the homepage of the plugin.
- `icon_data`: string
  - Base64 encoding of a plugin icon SVG.
- `download_url`: string
  - URL to download the plugin.
- `release_notes_url`: string
  - URL that leads to the release notes of the plugin.
- `labels`: array
  - A list of the plugin labels.
- `signature`: string
  - Base64 encoded signature of the plugin.
- `manifest`: PluginManifest
- `installed_version`: string
  - Version number of the already installed plugin, if any.

## Example JSON

```json
{"homepage_url": ""string"", "icon_data": ""string"", "download_url": ""string"", "release_notes_url": ""string"", "labels": [], "signature": ""string"", "manifest": "PluginManifest", "installed_version": ""string""}
```
