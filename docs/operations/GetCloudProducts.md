# Get cloud products

Original OpenAPI operationId: `GetCloudProducts`
- Method: `GET`
- Path: `/api/v4/cloud/products`
- Summary: Get cloud products
- Description: Retrieve a list of all products that are offered for Mattermost Cloud.
##### Permissions
Must have `manage_system` permission and be licensed for Cloud.
__Minimum server version__: 5.28 __Note:__ This is intended for internal use and is subject to change.

- Tags: cloud

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Cloud products returned successfully
  - `application/json` -> array of Product
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
