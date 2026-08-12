# Update cloud customer address

Original OpenAPI operationId: `UpdateCloudCustomerAddress`
- Method: `PUT`
- Path: `/api/v4/cloud/customer/address`
- Summary: Update cloud customer address
- Description: Updates the company address for the Mattermost Cloud customer bound to this installation.
##### Permissions
Must have `manage_system` permission and be licensed for Cloud.
__Minimum server version__: 5.29 __Note:__ This is intended for internal use and is subject to change.

- Tags: cloud

## Parameters
No parameters.

## Request body
- required: True
- description: Company address information to update
- content:
  - `application/json` -> Address

## Responses
- `200`: Cloud customer address updated successfully
  - `application/json` -> CloudCustomer
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
