# Save notify-admin intent

Original OpenAPI operationId: `NotifyAdmin`
- Method: `POST`
- Path: `/api/v4/users/notify-admin`
- Summary: Save notify-admin intent
- Description: Save a notify-admin request for upgrade or trial flows.
##### Permissions Must be authenticated.

- Tags: users

## Parameters
No parameters.

## Request body
- required: True
- content:
  - `application/json` -> NotifyAdminToUpgradeRequest

## Responses
- `200`: Notify-admin request saved
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
