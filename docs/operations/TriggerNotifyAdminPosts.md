# Trigger notify-admin posts

Original OpenAPI operationId: `TriggerNotifyAdminPosts`
- Method: `POST`
- Path: `/api/v4/users/trigger-notify-admin-posts`
- Summary: Trigger notify-admin posts
- Description: Trigger admin notification posts manually when enabled by configuration.
##### Permissions Must be authenticated and have `manage_system` permission.

- Tags: users

## Parameters
No parameters.

## Request body
- required: True
- content:
  - `application/json` -> NotifyAdminToUpgradeRequest

## Responses
- `200`: Notify-admin posts triggered successfully
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
