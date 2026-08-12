# ClientRegistrationRequest

Original OpenAPI schema: `ClientRegistrationRequest`

OAuth 2.0 Dynamic Client Registration request as defined in RFC 7591

## Fields

- `redirect_uris`: array (required)
  - Array of redirection URI strings for use in redirect-based flows such as the authorization code and implicit flows
- `client_name`: string
  - Human-readable string name of the client to be presented to the end-user during authorization
- `client_uri`: string
  - URL string of a web page providing information about the client

## Example JSON

```json
{"redirect_uris": [], "client_name": ""string"", "client_uri": ""string""}
```

