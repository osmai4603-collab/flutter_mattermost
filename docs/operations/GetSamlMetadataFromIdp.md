# Get metadata from Identity Provider

Original OpenAPI operationId: `GetSamlMetadataFromIdp`
- Method: `POST`
- Path: `/api/v4/saml/metadatafromidp`
- Summary: Get metadata from Identity Provider
- Description: Get SAML metadata from the Identity Provider. SAML must be configured properly.
##### Permissions
No permission required.

- Tags: SAML

## Parameters
No parameters.

## Request body
- required: False
- content:
  - `application/json` -> object

## Responses
- `200`: SAML metadata retrieval successful
  - `application/json` -> string
- `501`: No description available.
