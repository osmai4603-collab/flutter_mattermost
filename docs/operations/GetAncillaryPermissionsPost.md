# Return all system console subsection ancillary permissions

Original OpenAPI operationId: `GetAncillaryPermissionsPost`
- Method: `POST`
- Path: `/api/v4/permissions/ancillary`
- Summary: Return all system console subsection ancillary permissions
- Description: Returns all the ancillary permissions for the corresponding system console subsection permissions appended to the requested permission subsections. __Minimum server version__: 9.10

- Tags: permissions

## Parameters
No parameters.

## Request body
- required: True
- description: List of subsection permissions
- content:
  - `application/json` -> array of string

## Responses
- `200`: Successfully returned all ancillary and requested permissions
  - `application/json` -> array of string
- `400`: No description available.
