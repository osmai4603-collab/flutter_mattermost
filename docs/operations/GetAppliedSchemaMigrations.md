# Get applied database schema migrations

Original OpenAPI operationId: `GetAppliedSchemaMigrations`
- Method: `GET`
- Path: `/api/v4/system/schema/version`
- Summary: Get applied database schema migrations
- Description: Returns the list of applied database schema migrations.
##### Permissions Must have at least one sysconsole read permission.

- Tags: system

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Applied schema migrations retrieval successful
  - `application/json` -> array of object
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
