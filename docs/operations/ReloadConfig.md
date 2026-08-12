# Reload configuration

Original OpenAPI operationId: `ReloadConfig`
- Method: `POST`
- Path: `/api/v4/config/reload`
- Summary: Reload configuration
- Description: Reload the configuration file to pick up on any changes made to it.
##### Permissions
Must have `manage_system` permission.

- Tags: system

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Configuration reload successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `403`: No description available.
