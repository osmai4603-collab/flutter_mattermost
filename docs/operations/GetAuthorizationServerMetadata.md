# Get OAuth 2.0 Authorization Server Metadata

Original OpenAPI operationId: `GetAuthorizationServerMetadata`
- Method: `GET`
- Path: `/.well-known/oauth-authorization-server`
- Summary: Get OAuth 2.0 Authorization Server Metadata
- Description: Get the OAuth 2.0 Authorization Server Metadata as defined in RFC 8414. This endpoint provides metadata about the OAuth 2.0 authorization server's configuration, including supported endpoints, grant types, response types, and authentication methods.
##### Permissions
No authentication required. This endpoint is publicly accessible to allow OAuth clients to discover the authorization server's configuration.
##### Notes
- This endpoint implements RFC 8414 (OAuth 2.0 Authorization Server Metadata) - The metadata is dynamically generated based on the server's configuration - OAuth Service Provider must be enabled in system settings for this endpoint to be available

- Tags: OAuth

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Metadata retrieval successful
  - `application/json` -> AuthorizationServerMetadata
- `501`: OAuth Service Provider is not enabled
  - `application/json` -> AppError
