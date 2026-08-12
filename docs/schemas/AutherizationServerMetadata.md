# AutherizationServerMetadata

Original OpenAPI schema: `AuthorizationServerMetadata`

OAuth 2.0 Authorization Server Metadata as defined in RFC 8414

## Fields

- `issuer`: string (required)
  - The authorization server's issuer identifier, which is a URL that uses the "https" scheme
- `authorization_endpoint`: string
  - URL of the authorization server's authorization endpoint
- `token_endpoint`: string
  - URL of the authorization server's token endpoint
- `response_types_supported`: array (required)
  - JSON array containing a list of the OAuth 2.0 response_type values that this authorization server supports
- `registration_endpoint`: string
  - URL of the authorization server's OAuth 2.0 Dynamic Client Registration endpoint
- `scopes_supported`: array
  - JSON array containing a list of the OAuth 2.0 scope values that this authorization server supports
- `grant_types_supported`: array
  - JSON array containing a list of the OAuth 2.0 grant type values that this authorization server supports
- `token_endpoint_auth_methods_supported`: array
  - JSON array containing a list of client authentication methods supported by the token endpoint
- `code_challenge_methods_supported`: array
  - JSON array containing a list of PKCE code challenge methods supported by this authorization server

## Example JSON

```json
{"issuer": ""string"", "authorization_endpoint": ""string"", "token_endpoint": ""string"", "response_types_supported": [], "registration_endpoint": ""string"", "scopes_supported": [], "grant_types_supported": [], "token_endpoint_auth_methods_supported": [], "code_challenge_methods_supported": []}
```

