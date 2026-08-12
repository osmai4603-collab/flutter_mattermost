# Get autocomplete fields for access control policies

Original OpenAPI operationId: `GetAccessControlPolicyAutocompleteFields`
- Method: `GET`
- Path: `/api/v4/access_control_policies/cel/autocomplete/fields`
- Summary: Get autocomplete fields for access control policies
- Description: Provides a list of fields that can be used for autocompletion when creating/editing access control policy expressions.
##### Permissions
Must have the `manage_system` permission.

- Tags: access control

## Parameters
- `after` (query, optional, string) - The field ID to start after for pagination.
- `limit` (query, required, integer) - The maximum number of fields to return.

## Request body
No request body.

## Responses
- `200`: Autocomplete fields retrieved successfully.
  - `application/json` -> AccessControlFieldsAutocompleteResponse
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
