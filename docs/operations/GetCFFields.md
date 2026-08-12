# Get content flagging property fields

Original OpenAPI operationId: `GetCFFields`
- Method: `GET`
- Path: `/api/v4/content_flagging/fields`
- Summary: Get content flagging property fields
- Description: Returns the list of property fields that can be associated with content flagging reports. These fields are used for storing metadata about a post's flag.
An enterprise advanced license is required.

- Tags: Content Flagging

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Custom fields retrieved successfully
  - `application/json` -> object
- `404`: Feature is disabled via the feature flag.
- `500`: Internal server error.
- `501`: Feature is disabled either via config or an Enterprise Advanced license is not available.
