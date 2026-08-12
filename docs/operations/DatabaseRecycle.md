# Recycle database connections

Original OpenAPI operationId: `DatabaseRecycle`
- Method: `POST`
- Path: `/api/v4/database/recycle`
- Summary: Recycle database connections
- Description: Recycle database connections by closing and reconnecting all connections to master and read replica databases.
##### Permissions
Must have `manage_system` permission.

- Tags: system

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Database recycle successful
  - `application/json` -> StatusOK
- `403`: No description available.
