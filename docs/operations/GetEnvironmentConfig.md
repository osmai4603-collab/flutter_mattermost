# Get configuration made through environment variables

Original OpenAPI operationId: `GetEnvironmentConfig`
- Method: `GET`
- Path: `/api/v4/config/environment`
- Summary: Get configuration made through environment variables
- Description: Retrieve a json object mirroring the server configuration where fields are set to true
if the corresponding config setting is set through an environment variable. Settings
that haven't been set through environment variables will be missing from the object.

__Minimum server version__: 4.10

##### Permissions
Must have `manage_system` permission.

- Tags: system

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Configuration retrieval successful
  - `application/json` -> EnvironmentConfig
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
