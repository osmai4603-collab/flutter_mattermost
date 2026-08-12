# Get cloud customer

Original OpenAPI operationId: `GetCloudCustomer`
- Method: `GET`
- Path: `/api/v4/cloud/customer`
- Summary: Get cloud customer
- Description: Retrieves the customer information for the Mattermost Cloud customer bound to this installation.
##### Permissions
Must have `manage_system` permission and be licensed for Cloud.
__Minimum server version__: 5.28 __Note:__ This is intended for internal use and is subject to change.

- Tags: cloud

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Cloud customer returned successfully
  - `application/json` -> CloudCustomer
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
