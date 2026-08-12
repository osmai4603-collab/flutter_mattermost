# Open a dialog

Original OpenAPI operationId: `OpenInteractiveDialog`
- Method: `POST`
- Path: `/api/v4/actions/dialogs/open`
- Summary: Open a dialog
- Description: Open an interactive dialog using a trigger ID provided by a slash command, or some other action payload. See https://docs.mattermost.com/developer/interactive-dialogs.html for more information on interactive dialogs.

Up to 3 interactive dialogs may be open at once (minimum server version 11.10). Additional `open_dialog` events beyond this limit are silently ignored by the client.
__Minimum server version: 5.6__

- Tags: integration_actions

## Parameters
No parameters.

## Request body
- required: True
- description: Metadata for the dialog to be opened
- content:
  - `application/json` -> object

## Responses
- `200`: Dialog open successful
  - `application/json` -> StatusOK
- `400`: No description available.
