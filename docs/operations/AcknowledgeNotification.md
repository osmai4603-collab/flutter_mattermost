# Acknowledge receiving of a notification

Original OpenAPI operationId: `AcknowledgeNotification`
- Method: `POST`
- Path: `/api/v4/notifications/ack`
- Summary: Acknowledge receiving of a notification
- Description: __Minimum server version__: 3.10
##### Permissions
Must be logged in.

- Tags: root

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Status of the system
  - `application/json` -> PushNotification
- `404`: No description available.
