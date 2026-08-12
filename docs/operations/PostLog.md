# Add log message

Original OpenAPI operationId: `PostLog`
- Method: `POST`
- Path: `/api/v4/logs`
- Summary: Add log message
- Description: Add log messages to the server logs.
##### Permissions
Users with `manage_system` permission can log ERROR or DEBUG messages.
Logged in users can log ERROR or DEBUG messages when `ServiceSettings.EnableDeveloper` is `true` or just DEBUG messages when `false`.
Non-logged in users can log ERROR or DEBUG messages when `ServiceSettings.EnableDeveloper` is `true` and cannot log when `false`.

- Tags: system

## Parameters
No parameters.

## Request body
- required: True
- content:
  - `application/json` -> object

## Responses
- `200`: Logs sent successful
  - `application/json` -> object
- `403`: No description available.
