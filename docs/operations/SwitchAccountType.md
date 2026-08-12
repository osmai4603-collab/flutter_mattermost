# Switch login method

Original OpenAPI operationId: `SwitchAccountType`
- Method: `POST`
- Path: `/api/v4/users/login/switch`
- Summary: Switch login method
- Description: Switch a user's login method from using email to OAuth2/SAML/LDAP or back to email. When switching to OAuth2/SAML, account switching is not complete until the user follows the returned link and completes any steps on the OAuth2/SAML service provider.

To switch from email to OAuth2/SAML, specify `current_service`, `new_service`, `email` and `password`.

To switch from OAuth2/SAML to email, specify `current_service`, `new_service`, `email` and `new_password`.

To switch from email to LDAP/AD, specify `current_service`, `new_service`, `email`, `password`, `ldap_ip` and `new_password` (this is the user's LDAP password).

To switch from LDAP/AD to email, specify `current_service`, `new_service`, `ldap_ip`, `password` (this is the user's LDAP password), `email`  and `new_password`.

Additionally, specify `mfa_code` when trying to switch an account on LDAP/AD or email that has MFA activated.

##### Permissions
No current authentication required except when switching from OAuth2/SAML to email.

- Tags: users

## Parameters
No parameters.

## Request body
- required: True
- content:
  - `application/json` -> object

## Responses
- `200`: Login method switch or request successful
  - `application/json` -> object
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `501`: No description available.
