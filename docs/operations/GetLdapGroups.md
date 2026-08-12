# Returns a list of LDAP groups

Original OpenAPI operationId: `GetLdapGroups`
- Method: `GET`
- Path: `/api/v4/ldap/groups`
- Summary: Returns a list of LDAP groups
- Description: ##### Permissions
Must have `manage_system` permission.
__Minimum server version__: 5.11

- Tags: LDAP

## Parameters
- `q` (query, optional, string) - Search term
- `page` (query, optional, integer) - The page to select.
- `per_page` (query, optional, integer) - The number of users per page. per page.

## Request body
No request body.

## Responses
- `200`: LDAP group page retrieval successful
  - `application/json` -> array of LDAPGroupsPaged
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
