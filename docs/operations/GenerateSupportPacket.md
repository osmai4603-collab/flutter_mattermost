# Download a zip file which contains helpful and useful information for troubleshooting your mattermost instance.

Original OpenAPI operationId: `GenerateSupportPacket`
- Method: `GET`
- Path: `/api/v4/system/support_packet`
- Summary: Download a zip file which contains helpful and useful information for troubleshooting your mattermost instance.
- Description: Download a zip file which contains helpful and useful information for troubleshooting your mattermost instance.
__Minimum server version: 5.32__
##### Permissions
Must have any of the system console read permissions.
##### License
Requires either a E10 or E20 license.

- Tags: system

## Parameters
- `basic_server_logs` (query, optional, boolean) - Specifies whether the server should include or exclude log files. Default value is true.

__Minimum server version__: 9.8.0

- `plugin_packets` (query, optional, string) - Specifies plugin identifiers whose content should be included in the Support Packet.

__Minimum server version__: 9.8.0


## Request body
No request body.

## Responses
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
