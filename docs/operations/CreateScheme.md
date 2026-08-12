# Create a scheme

Original OpenAPI operationId: `CreateScheme`
- Method: `POST`
- Path: `/api/v4/schemes`
- Summary: Create a scheme
- Description: Create a new scheme.

##### Permissions
Must have `manage_system` permission.

__Minimum server version__: 5.0

- Tags: schemes

## Parameters
No parameters.

## Request body
- required: True
- description: Scheme object to create
- content:
  - `application/json` -> object

## Responses
- `201`: Scheme creation successful
  - `application/json` -> Scheme
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
