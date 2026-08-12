# PushNotification

Original OpenAPI schema: `PushNotification`

No description available in the official OpenAPI schema.

## Fields

- `ack_id`: string
- `platform`: string
- `server_id`: string
- `device_id`: string
- `post_id`: string
- `category`: string
- `sound`: string
- `message`: string
- `badge`: number
- `cont_ava`: number
- `team_id`: string
- `channel_id`: string
- `root_id`: string
- `channel_name`: string
- `type`: string
- `sub_type`: string
  - Additional message type information for mobile clients. Use "calls" for Calls plugin notifications.
- `transport`: string
  - Delivery path for the push proxy. Use "voip" for VoIP (CallKit) notifications; omit for standard delivery.
- `sender_id`: string
- `sender_name`: string
- `override_username`: string
- `override_icon_url`: string
- `from_webhook`: string
- `version`: string
- `is_crt_enabled`: boolean
  - Whether Collapsed Reply Threads is enabled for the recipient.
- `is_id_loaded`: boolean
- `signature`: string

## Example JSON

```json
{"ack_id": ""string"", "platform": ""string"", "server_id": ""string"", "device_id": ""string"", "post_id": ""string"", "category": ""string"", "sound": ""string"", "message": ""string"", "badge": 0.0, "cont_ava": 0.0, "team_id": ""string"", "channel_id": ""string"", "root_id": ""string"", "channel_name": ""string"", "type": ""string"", "sub_type": ""string"", "transport": ""string"", "sender_id": ""string"", "sender_name": ""string"", "override_username": ""string"", "override_icon_url": ""string"", "from_webhook": ""string"", "version": ""string"", "is_crt_enabled": False, "is_id_loaded": False, "signature": ""string""}
```
