# Get the system content flagging configuration

Original OpenAPI operationId: `GetCFConfig`
- Method: `GET`
- Path: `/api/v4/content_flagging/config`
- Summary: Get the system content flagging configuration
- Description: Returns the system configuration for content flagging, including settings related to notifications, flagging configurations, etc..
Only system admins can access this endpoint.

- Tags: Content Flagging

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Configuration retrieved successfully
  - `application/json` -> ContentFlaggingConfig
- `403`: User does not have permission to manage system configuration.
- `404`: Feature is disabled via the feature flag.
- `500`: Internal server error.
