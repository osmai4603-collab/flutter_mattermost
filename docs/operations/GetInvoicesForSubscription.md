# Get cloud subscription invoices

Original OpenAPI operationId: `GetInvoicesForSubscription`
- Method: `GET`
- Path: `/api/v4/cloud/subscription/invoices`
- Summary: Get cloud subscription invoices
- Description: Retrieves the invoices for the subscription bound to this installation.
##### Permissions
Must have `manage_system` permission and be licensed for Cloud.
__Minimum server version__: 5.30 __Note:__ This is intended for internal use and is subject to change.

- Tags: cloud

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Subscription invoices returned successfully
  - `application/json` -> array of Invoice
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
