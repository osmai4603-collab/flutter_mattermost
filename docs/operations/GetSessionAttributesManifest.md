# Get the session attributes manifest

Original OpenAPI operationId: `GetSessionAttributesManifest`
- Method: `GET`
- Path: `/api/v4/users/sessions/attributes/manifest`
- Summary: Get the session attributes manifest
- Description: Get the set of session attributes the server expects the client to collect, filtered to the requesting client's platform, including the per-attribute TTL and grace period.
Requires the `SessionAttributes` feature flag and an Enterprise Advanced license.

- Tags: users

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Session attributes manifest retrieval successful
  - `application/json` -> array of object
- `501`: No description available.
