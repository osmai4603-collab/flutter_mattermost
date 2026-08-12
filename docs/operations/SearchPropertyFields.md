# Search property fields across multiple object types

Original OpenAPI operationId: `SearchPropertyFields`
- Method: `POST`
- Path: `/api/v4/properties/groups/{group_name}/fields/search`
- Summary: Search property fields across multiple object types
- Description: Returns matching fields across every requested object type in one response. The request body is a `PropertyFieldSearch` object whose `object_types` field lists the object types to include.
Scope, `since`, cursor, and permission semantics are identical to the get property fields endpoint, including the system-object collapse: when `object_types` is exactly `["system"]`, any scope or target params in the body are ignored and the endpoint resolves to `target_type=system`. Any other combination without an explicit scope returns 400.
Requesting a single value in `object_types` is equivalent to calling the singular endpoint and is supported for client uniformity.

- Tags: properties

## Parameters
- `group_name` (path, required, string) - The name of the property group

## Request body
- required: True
- content:
  - `application/json` -> object

## Responses
- `200`: Property fields retrieval successful
  - `application/json` -> array of PropertyField
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
