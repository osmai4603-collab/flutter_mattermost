# Migrate config storage

Original OpenAPI operationId: `MigrateConfig`
- Method: `POST`
- Path: `/api/v4/config/migrate`
- Summary: Migrate config storage
- Description: Migrate configuration between storage backends.
This endpoint is only exposed over a local socket.

##### Permissions
Must have `manage_system` permission.

- Tags: system

## Parameters
No parameters.

## Request body
- required: False
- content:
  - `application/json` -> object

## Responses
- `200`: Config migration successful
- `400`: No description available.
- `403`: No description available.
- `500`: No description available.
