# Patch a scheme

Original OpenAPI operationId: `PatchScheme`
- Method: `PUT`
- Path: `/api/v4/schemes/{scheme_id}/patch`
- Summary: Patch a scheme
- Description: Partially update a scheme by providing only the fields you want to update. Omitted fields will not be updated. The fields that can be updated are defined in the request body, all other provided fields will be ignored.

##### Permissions
`manage_system` permission is required.

__Minimum server version__: 5.0

- Tags: schemes

## Parameters
- `scheme_id` (path, required, string) - Scheme GUID

## Request body
- required: True
- description: Scheme object to be updated
- content:
  - `application/json` -> object

## Responses
- `200`: Scheme patch successful
  - `application/json` -> Scheme
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `501`: No description available.
