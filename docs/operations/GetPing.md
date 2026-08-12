# Check system health

Original OpenAPI operationId: `GetPing`
- Method: `GET`
- Path: `/api/v4/system/ping`
- Summary: Check system health
- Description: Check if the server is up and healthy based on the configuration setting `GoRoutineHealthThreshold`. If `GoRoutineHealthThreshold` and the number of goroutines on the server exceeds that threshold the server is considered unhealthy. If `GoRoutineHealthThreshold` is not set or the number of goroutines is below the threshold the server is considered healthy.
__Minimum server version__: 3.10
If a "device_id" is passed in the query, it will test the Push Notification Proxy in order to discover whether the device is able to receive notifications. The response will have a "CanReceiveNotifications" property with one of the following values: - true: It can receive notifications - false: It cannot receive notifications - unknown: There has been an unknown error, and it is not certain whether it can

  receive notifications.

__Minimum server version__: 6.5
If "use_rest_semantics" is set to true in the query, the endpoint will not return an error status code in the header if the request is somehow completed successfully.
__Minimum server version__: 9.6
##### Permissions
None. Authentication is not required for this endpoint.
##### Response Details
The response varies based on query parameters and authentication:
- **Basic response** (no parameters): Returns basic server information including

  `status`, mobile app versions, and active search backend.

- **Enhanced response** (`get_server_status=true`): Additionally returns

  `database_status` and `filestore_status` to verify backend connectivity.
  Authentication is not required.

- **Admin response** (`get_server_status=true` with `manage_system` permission):

  Additionally returns `root_status` indicating whether the server is running as root.
  Requires authentication with `manage_system` permission.

- Tags: system

## Parameters
- `get_server_status` (query, optional, boolean) - Check the status of the database and file storage as well. When true, adds `database_status` and `filestore_status` to the response. If authenticated with `manage_system` permission, also adds `root_status`.

- `device_id` (query, optional, string) - Check whether this device id can receive push notifications
- `use_rest_semantics` (query, optional, boolean) - Returns 200 status code even if the server status is unhealthy.

## Request body
No request body.

## Responses
- `200`: Status of the system
  - `application/json` -> SystemStatusResponse
- `500`: No description available.
