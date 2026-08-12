# Get cloud preview modal data

Original OpenAPI operationId: `GetPreviewModalData`
- Method: `GET`
- Path: `/api/v4/cloud/preview/modal_data`
- Summary: Get cloud preview modal data
- Description: Retrieves modal content data from the configured S3 bucket for displaying cloud product preview modals.
##### Permissions
Must be authenticated. Must be in a Cloud Preview environment.
__Minimum server version__: 10.0 __Note:__ This is intended for internal use and is subject to change.

- Tags: cloud

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Preview modal data returned successfully
  - `application/json` -> array of PreviewModalContentData
- `401`: No description available.
- `404`: No description available.
- `500`: No description available.
