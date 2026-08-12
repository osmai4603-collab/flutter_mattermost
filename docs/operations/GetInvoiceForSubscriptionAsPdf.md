# Get cloud invoice PDF

Original OpenAPI operationId: `GetInvoiceForSubscriptionAsPdf`
- Method: `GET`
- Path: `/api/v4/cloud/subscription/invoices/{invoice_id}/pdf`
- Summary: Get cloud invoice PDF
- Description: Retrieves the PDF for the invoice passed as parameter
##### Permissions
Must have `manage_system` permission and be licensed for Cloud.
__Minimum server version__: 5.30 __Note:__ This is intended for internal use and is subject to change.

- Tags: cloud

## Parameters
- `invoice_id` (path, required, string) - Invoice ID

## Request body
No request body.

## Responses
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
