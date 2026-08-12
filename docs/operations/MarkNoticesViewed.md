# Update notices as 'viewed'

Original OpenAPI operationId: `MarkNoticesViewed`
- Method: `PUT`
- Path: `/api/v4/system/notices/view`
- Summary: Update notices as 'viewed'
- Description: Will mark the specified notices as 'viewed' by the logged in user.
__Minimum server version__: 5.26
##### Permissions
Must be logged in.

- Tags: system

## Parameters
No parameters.

## Request body
- required: True
- description: Array of notice IDs
- content:
  - `application/json` -> array of string

## Responses
- `200`: Update successfull
  - `application/json` -> StatusOK
- `500`: No description available.
