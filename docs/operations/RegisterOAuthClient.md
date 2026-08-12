# Register OAuth client using Dynamic Client Registration

Original OpenAPI operationId: `RegisterOAuthClient`
- Method: `POST`
- Path: `/api/v4/oauth/apps/register`
- Summary: Register OAuth client using Dynamic Client Registration
- Description: Register an OAuth 2.0 client application using Dynamic Client Registration (DCR) as defined in RFC 7591. This endpoint allows clients to register without requiring administrative approval.
##### Permissions
No authentication required. This endpoint implements the OAuth 2.0 Dynamic Client Registration Protocol and can be called by unauthenticated clients.
##### Notes
- This endpoint follows RFC 7591 (OAuth 2.0 Dynamic Client Registration Protocol) - The `client_uri` field, when provided, will be mapped to the OAuth app's homepage - All registered clients are marked as dynamically registered - Dynamic client registration must be enabled in system settings

- Tags: OAuth

## Parameters
No parameters.

## Request body
- required: True
- description: OAuth client registration request
- content:
  - `application/json` -> ClientRegistrationRequest

## Responses
- `201`: Client registration successful
  - `application/json` -> ClientRegistrationResponse
- `400`: No description available.
- `501`: No description available.
