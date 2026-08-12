# Get if the Plugin Marketplace has been visited by at least an admin.

Original OpenAPI operationId: `GetMarketplaceVisitedByAdmin`
- Method: `GET`
- Path: `/api/v4/plugins/marketplace/first_admin_visit`
- Summary: Get if the Plugin Marketplace has been visited by at least an admin.
- Description: Retrieves the status that specifies that at least one System Admin has visited the in-product Plugin Marketplace.
__Minimum server version: 5.33__
##### Permissions
Must have `manage_system` permissions.

- Tags: plugins

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Retrieves the system-level status
  - `application/json` -> System
- `403`: No description available.
- `500`: No description available.
