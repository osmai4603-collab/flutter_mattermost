# Get cloud subscription

Original OpenAPI operationId: `GetSubscription`
- Method: `GET`
- Path: `/api/v4/cloud/subscription`
- Summary: Get cloud subscription
- Description: Retrieves the subscription information for the Mattermost Cloud customer bound to this installation.
##### Permissions
Must have `manage_system` permission and be licensed for Cloud.
__Minimum server version__: 5.28 __Note:__ This is intended for internal use and is subject to change.

- Tags: cloud

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Cloud subscription returned successfully
  - `application/json` -> Subscription
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
