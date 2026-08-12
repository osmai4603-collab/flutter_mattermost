# Submit a dialog

Original OpenAPI operationId: `SubmitInteractiveDialog`
- Method: `POST`
- Path: `/api/v4/actions/dialogs/submit`
- Summary: Submit a dialog
- Description: Endpoint used by the Mattermost clients to submit a dialog. See https://docs.mattermost.com/developer/interactive-dialogs.html for more information on interactive dialogs.
__Minimum server version: 5.6__

- Tags: integration_actions

## Parameters
No parameters.

## Request body
- required: True
- description: Dialog submission data
- content:
  - `application/json` -> object

## Responses
- `200`: Dialog submission successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `429`: The upstream integration rate-limited the request. The original status code is preserved so clients can honor retry semantics.
  - `application/json` -> AppError
- `502`: The upstream integration returned a 5xx (other than 503). Surfaced as Bad Gateway because the failure is upstream of Mattermost.
  - `application/json` -> AppError
- `503`: The upstream integration is unavailable. The original status code is preserved so clients can honor retry semantics.
  - `application/json` -> AppError
