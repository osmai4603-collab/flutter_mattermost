# ClientRegistrationResponse

Original OpenAPI schema: `ClientRegistrationResponse`

OAuth 2.0 Dynamic Client Registration response as defined in RFC 7591

## Fields

- `client_id`: string
  - OAuth 2.0 client identifier string
- `client_secret`: string
  - OAuth 2.0 client secret string
- `redirect_uris`: array
  - Array of the registered redirection URI strings
- `token_endpoint_auth_method`: string
  - String indicator of the requested authentication method for the token endpoint
- `grant_types`: array
  - Array of OAuth 2.0 grant type strings that the client can use at the token endpoint
- `response_types`: array
  - Array of the OAuth 2.0 response type strings that the client can use at the authorization endpoint
- `scope`: string
  - Space-separated list of scope values that the client can use when requesting access tokens
- `client_name`: string
  - Human-readable string name of the client to be presented to the end-user during authorization
- `client_uri`: string
  - URL string of a web page providing information about the client

## Example JSON

```json
{"client_id": ""string"", "client_secret": ""string"", "redirect_uris": [], "token_endpoint_auth_method": ""string"", "grant_types": [], "response_types": [], "scope": ""string"", "client_name": ""string"", "client_uri": ""string""}
```

