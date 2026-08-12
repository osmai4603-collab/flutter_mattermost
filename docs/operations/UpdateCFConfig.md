# Update the system content flagging configuration

Original OpenAPI operationId: `UpdateCFConfig`
- Method: `PUT`
- Path: `/api/v4/content_flagging/config`
- Summary: Update the system content flagging configuration
- Description: Updates the system configuration for content flagging, including settings related to notifications, flagging configurations, etc..
Only system admins can access this endpoint.

- Tags: Content Flagging

## Parameters
No parameters.

## Request body
- required: True
- content:
  - `application/json` -> ContentFlaggingConfig

## Responses
- `200`: Configuration updated successfully
- `400`: Bad request - Invalid input data or missing required fields.
- `403`: User does not have permission to manage system configuration.
- `404`: Feature is disabled via the feature flag.
- `500`: Internal server error.
