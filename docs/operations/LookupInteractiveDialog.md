# Lookup dialog elements

Original OpenAPI operationId: `LookupInteractiveDialog`
- Method: `POST`
- Path: `/api/v4/actions/dialogs/lookup`
- Summary: Lookup dialog elements
- Description: Endpoint used by the Mattermost clients to lookup dynamic dialog elements. See https://docs.mattermost.com/developer/interactive-dialogs.html for more information on interactive dialogs.
__Minimum server version: 11.0__

- Tags: integration_actions

## Parameters
No parameters.

## Request body
- required: True
- description: Dialog lookup request data
- content:
  - `application/json` -> object

## Responses
- `200`: Dialog lookup successful
  - `application/json` -> object
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `429`: The upstream integration rate-limited the request. The original status code is preserved so clients can honor retry semantics.
  - `application/json` -> AppError
- `502`: The upstream integration returned a 5xx (other than 503). Surfaced as Bad Gateway because the failure is upstream of Mattermost.
  - `application/json` -> AppError
- `503`: The upstream integration is unavailable. The original status code is preserved so clients can honor retry semantics.
  - `application/json` -> AppError
