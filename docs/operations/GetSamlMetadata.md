# Get metadata

Original OpenAPI operationId: `GetSamlMetadata`
- Method: `GET`
- Path: `/api/v4/saml/metadata`
- Summary: Get metadata
- Description: Get SAML metadata from the server. SAML must be configured properly.
##### Permissions
No permission required.

- Tags: SAML

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: SAML metadata retrieval successful
  - `application/json` -> string
- `501`: No description available.
