# Exchange SSO login code for session tokens

Original OpenAPI operationId: `LoginSSOCodeExchange`
- Method: `POST`
- Path: `/api/v4/users/login/sso/code-exchange`
- Summary: Exchange SSO login code for session tokens
- Description: Exchange a short-lived login_code for session tokens using SAML code exchange (mobile SSO flow).
**Deprecated:** This endpoint is deprecated and will be removed in a future release. Mobile clients should use the direct SSO callback flow instead.
##### Permissions
No permission required.

- Tags: users
- Deprecated: True

## Parameters
No parameters.

## Request body
- required: True
- description: SSO code exchange object
- content:
  - `application/json` -> object

## Responses
- `200`: Code exchange successful
  - `application/json` -> object
- `400`: No description available.
- `403`: No description available.
- `410`: Endpoint is deprecated and disabled
