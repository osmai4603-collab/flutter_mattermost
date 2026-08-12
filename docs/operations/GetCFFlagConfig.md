# Get content flagging configuration

Original OpenAPI operationId: `GetCFFlagConfig`
- Method: `GET`
- Path: `/api/v4/content_flagging/flag/config`
- Summary: Get content flagging configuration
- Description: Returns the configuration for content flagging, including the list of available reasons for flagging content. This data is used to gather details from the user when they flag content.
An enterprise advanced license is required.

- Tags: Content Flagging

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Configuration retrieved successfully
  - `application/json` -> object
- `404`: Feature is disabled via the feature flag.
- `500`: Internal server error.
- `501`: Feature is disabled either via config or an Enterprise Advanced license is not available.
