# Invalidate all the caches

Original OpenAPI operationId: `InvalidateCaches`
- Method: `POST`
- Path: `/api/v4/caches/invalidate`
- Summary: Invalidate all the caches
- Description: Purge all the in-memory caches for the Mattermost server. This can have a temporary negative effect on performance while the caches are re-populated.
##### Permissions
Must have `manage_system` permission.

- Tags: system

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Caches invalidate successful
  - `application/json` -> StatusOK
- `403`: No description available.
