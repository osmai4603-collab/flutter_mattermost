# IntuneLoginRequest

Original OpenAPI schema: `IntuneLoginRequest`

Request body for Microsoft Intune MAM authentication using Azure AD/Entra ID access token

## Fields

- `access_token`: string (required)
  - Microsoft Entra ID access token obtained via MSAL (Microsoft Authentication Library). This token must be scoped to the Intune MAM app registration and will be validated against the configured tenant.
- `device_id`: string
  - Optional mobile device identifier used for push notifications. If provided, the device will be registered for receiving push notifications.
- `voip_device_id`: string
  - Optional VoIP push token. Same prefix shape as device_id. When provided, enables ring-style call push notifications.

## Example JSON

```json
{"access_token": ""string"", "device_id": ""string"", "voip_device_id": ""string""}
```

