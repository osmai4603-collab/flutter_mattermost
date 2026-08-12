# Migrate user accounts authentication type to LDAP.

Original OpenAPI operationId: `MigrateAuthToLdap`
- Method: `POST`
- Path: `/api/v4/users/migrate_auth/ldap`
- Summary: Migrate user accounts authentication type to LDAP.
- Description: Migrates accounts from one authentication provider to another. For example, you can upgrade your authentication provider from email to LDAP.
__Minimum server version__: 5.28
##### Permissions
Must have `manage_system` permission.

- Tags: users, migrate, authentication, LDAP

## Parameters
No parameters.

## Request body
- required: False
- content:
  - `application/json` -> object

## Responses
- `200`: Successfully migrated authentication type to LDAP.
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
