# Update cloud customer

Original OpenAPI operationId: `UpdateCloudCustomer`
- Method: `PUT`
- Path: `/api/v4/cloud/customer`
- Summary: Update cloud customer
- Description: Updates the customer information for the Mattermost Cloud customer bound to this installation.
##### Permissions
Must have `manage_system` permission and be licensed for Cloud.
__Minimum server version__: 5.29 __Note:__ This is intended for internal use and is subject to change.

- Tags: cloud

## Parameters
No parameters.

## Request body
- required: True
- description: Customer patch including information to update
- content:
  - `application/json` -> object

## Responses
- `200`: Cloud customer updated successfully
  - `application/json` -> CloudCustomer
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
