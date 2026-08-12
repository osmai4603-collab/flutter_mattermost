# Activate or deactivate a user

Original OpenAPI operationId: `UpdateUserActive`
- Method: `PUT`
- Path: `/api/v4/users/{user_id}/active`
- Summary: Activate or deactivate a user
- Description: Activate or deactivate a user's account. A deactivated user can't log into Mattermost or use it without being reactivated.

__Since server version 4.6, users using a SSO provider to login can be activated or deactivated with this endpoint. However, if their activation status in Mattermost does not reflect their status in the SSO provider, the next synchronization or login by that user will reset the activation status to that of their account in the SSO provider. Server versions 4.5 and before do not allow activation or deactivation of SSO users from this endpoint.__
##### Permissions
User can deactivate themselves.
User with `manage_system` permission can activate or deactivate a user.

- Tags: users

## Parameters
- `user_id` (path, required, string) - User GUID

## Request body
- required: True
- description: Use `true` to activate the user or `false` to deactivate them
- content:
  - `application/json` -> object

## Responses
- `200`: User activation/deactivation update successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
