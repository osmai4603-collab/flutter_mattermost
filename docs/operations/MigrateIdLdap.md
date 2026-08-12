# Migrate Id LDAP

Original OpenAPI operationId: `MigrateIdLdap`
- Method: `POST`
- Path: `/api/v4/ldap/migrateid`
- Summary: Migrate Id LDAP
- Description: Migrate LDAP IdAttribute to new value.
##### Permissions
Must have `manage_system` permission.
__Minimum server version__: 5.26

- Tags: LDAP

## Parameters
No parameters.

## Request body
- required: True
- content:
  - `application/json` -> object

## Responses
- `200`: Migration successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
- `501`: No description available.
