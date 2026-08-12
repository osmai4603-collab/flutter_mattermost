# Login with Microsoft Intune MAM

Original OpenAPI operationId: `LoginIntune`
- Method: `POST`
- Path: `/oauth/intune`
- Summary: Login with Microsoft Intune MAM
- Description: Authenticate a mobile user using a Microsoft Entra ID (Azure AD) access token for Intune Mobile Application Management (MAM) protected apps.

This endpoint enables authentication for mobile apps protected by Microsoft Intune MAM policies. The access token is obtained via the Microsoft Authentication Library (MSAL) and validated against the configured Azure AD tenant and Intune MAM app registration.

**Authentication Flow:**
1. Mobile app acquires an Entra ID access token via MSAL with the Intune MAM scope
2. Token is sent to this endpoint for validation
3. Server validates the token signature, claims, and tenant configuration
4. User is authenticated or created based on the token claims
5. Session token is returned for subsequent API requests

**User Provisioning:**
- **Office365 AuthService**: Users are automatically created on first login using the `oid` (Azure AD object ID) claim as the unique identifier
- **SAML AuthService**: Users must first login via web/desktop to establish their account with the `oid` (Azure AD object ID) as AuthData. Intune MAM  always uses objectId for SAML users. For Entra ID Domain Services LDAP sync, configure LdapSettings.IdAttribute to `msDS-aadObjectId` to ensure consistency.

**Error Handling:**
This endpoint returns specific HTTP status codes to help mobile apps handle different error scenarios:
- `428 Precondition Required`: SAML user needs to login via web/desktop first
- `403 Forbidden`: Configuration issues or bot accounts
- `409 Conflict`: User account is deactivated
- `401 Unauthorized`: Token has expired
- `400 Bad Request`: Invalid token format, claims, or configuration

##### Permissions

No permission required. Authentication is performed via the Entra ID access token.

##### Enterprise Feature

Requires Mattermost Enterprise Advanced license and proper Intune MAM configuration (tenant ID, client ID, and auth service).

- Tags: users

## Parameters
No parameters.

## Request body
- required: True
- description: Intune login credentials containing the Entra ID access token
- content:
  - `application/json` -> IntuneLoginRequest

## Responses
- `200`: User authentication successful
  - `application/json` -> User
- `400`: Bad request - Invalid token format, signature, claims, or configuration. Common causes include: invalid JSON body, missing access_token, malformed JWT, invalid token issuer/audience/tenant, missing required claims (oid, email), or empty auth data after extraction.

  - `application/json` -> AppError
- `401`: Unauthorized - The Entra ID access token has expired
  - `application/json` -> AppError
- `403`: Forbidden - Access denied. Common causes include: Intune MAM not properly configured or enabled, or user is a bot account (bots cannot use Intune login).

  - `application/json` -> AppError
- `409`: Conflict - User account has been deactivated (DeleteAt != 0)
  - `application/json` -> AppError
- `428`: Precondition Required - SAML user account not found. The user must first login via web or desktop application to establish their Mattermost account with objectId as AuthData before using mobile Intune MAM authentication. For Entra ID Domain Services LDAP sync, ensure SamlSettings.IdAttribute references the objectidentifier claim and LdapSettings.IdAttribute is set to 'msDS-aadObjectId'.

  - `application/json` -> AppError
- `500`: Internal Server Error - Server-side error. Common causes include: failed to initialize JWKS (JSON Web Key Set) from Microsoft's OpenID configuration, or failed to create user session.

  - `application/json` -> AppError
- `501`: Not Implemented - Intune MAM feature is not available. This occurs when running Mattermost Team Edition or when enterprise features are not loaded.

  - `application/json` -> AppError
