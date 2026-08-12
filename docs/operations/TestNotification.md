# Send a test notification

Original OpenAPI operationId: `TestNotification`
- Method: `POST`
- Path: `/api/v4/notifications/test`
- Summary: Send a test notification
- Description: Send a test notification to make sure you have your notification settings configured correctly.
##### Permissions
Must be logged in.

- Tags: system

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Notification successfully sent
  - `application/json` -> StatusOK
- `403`: No description available.
- `500`: No description available.
