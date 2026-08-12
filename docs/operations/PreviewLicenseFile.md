# Preview license file

Original OpenAPI operationId: `PreviewLicenseFile`
- Method: `POST`
- Path: `/api/v4/license/preview`
- Summary: Preview license file
- Description: Validate and parse a license file without saving it. This allows administrators
to preview the license details before applying it.

__Minimum server version__: 10.9

##### Permissions
Must have `manage_license_information` permission.

- Tags: system

## Parameters
No parameters.

## Request body
- required: False
- content:
  - `multipart/form-data` -> object

## Responses
- `200`: License preview successful
  - `application/json` -> object
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `413`: No description available.
