# Revoke non-compliant personal access tokens

Original OpenAPI operationId: `RevokeNonCompliantUserAccessTokens`
- Method: `POST`
- Path: `/api/v4/users/tokens/non_compliant/revoke`
- Summary: Revoke non-compliant personal access tokens
- Description: Revoke (hard-delete) every active personal access token that violates the configured `ServiceSettings.MaximumPersonalAccessTokenLifetimeDays` policy, along with any sessions created from them, and return the number of tokens revoked. Bot account tokens are exempt. The request is rejected with 400 when no maximum lifetime is configured, since there is nothing to revoke. This is irreversible; use `/users/tokens/non_compliant/count` first to preview the blast radius.

__Minimum server version__: 11.1

##### Permissions
Must have `manage_system` permission.

- Tags: users

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Non-compliant tokens revoked successfully
  - `application/json` -> object
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
