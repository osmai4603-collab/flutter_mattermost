# SystemStatusResponse

Original OpenAPI schema: `SystemStatusResponse`

No description available in the official OpenAPI schema.

## Fields

- `AndroidLatestVersion`: string
  - Latest Android version supported
- `AndroidMinVersion`: string
  - Minimum Android version supported
- `DesktopLatestVersion`: string
  - Latest desktop version supported
- `DesktopMinVersion`: string
  - Minimum desktop version supported
- `IosLatestVersion`: string
  - Latest iOS version supported
- `IosMinVersion`: string
  - Minimum iOS version supported
- `database_status`: string
  - Status of database ("OK" or "UNHEALTHY"). Included when get_server_status parameter set.
- `filestore_status`: string
  - Status of filestore ("OK" or "UNHEALTHY"). Included when get_server_status parameter set.
- `status`: string
  - Status of server ("OK" or "UNHEALTHY"). Included when get_server_status parameter set.
- `CanReceiveNotifications`: string
  - Whether the device id provided can receive notifications ("true", "false" or "unknown"). Included when device_id parameter set.

## Example JSON

```json
{"AndroidLatestVersion": ""string"", "AndroidMinVersion": ""string"", "DesktopLatestVersion": ""string"", "DesktopMinVersion": ""string"", "IosLatestVersion": ""string"", "IosMinVersion": ""string"", "database_status": ""string"", "filestore_status": ""string"", "status": ""string"", "CanReceiveNotifications": ""string""}
```
