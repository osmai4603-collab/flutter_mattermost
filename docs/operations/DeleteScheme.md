# Delete a scheme

Original OpenAPI operationId: `DeleteScheme`
- Method: `DELETE`
- Path: `/api/v4/schemes/{scheme_id}`
- Summary: Delete a scheme
- Description: Soft deletes a scheme, by marking the scheme as deleted in the database.

##### Permissions
Must have `manage_system` permission.

__Minimum server version__: 5.0

- Tags: schemes

## Parameters
- `scheme_id` (path, required, string) - ID of the scheme to delete

## Request body
No request body.

## Responses
- `200`: Scheme deletion successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
