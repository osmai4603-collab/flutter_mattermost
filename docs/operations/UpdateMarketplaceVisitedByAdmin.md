# Stores that the Plugin Marketplace has been visited by at least an admin.

Original OpenAPI operationId: `UpdateMarketplaceVisitedByAdmin`
- Method: `POST`
- Path: `/api/v4/plugins/marketplace/first_admin_visit`
- Summary: Stores that the Plugin Marketplace has been visited by at least an admin.
- Description: Stores the system-level status that specifies that at least an admin has visited the in-product Plugin Marketplace.
__Minimum server version: 5.33__
##### Permissions
Must have `manage_system` permissions.

- Tags: system

## Parameters
No parameters.

## Request body
- required: True
- content:
  - `application/json` -> System

## Responses
- `200`: setting has been successfully set
  - `application/json` -> StatusOK
- `403`: No description available.
- `500`: No description available.
