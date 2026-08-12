# Execute a dialog action button

Original OpenAPI operationId: `ExecuteDialogAction`
- Method: `POST`
- Path: `/api/v4/actions/dialogs/execute`
- Summary: Execute a dialog action button
- Description: Endpoint used by the Mattermost clients when a user clicks an `action_button` element inside an interactive dialog. The server generates a new trigger ID and forwards the button's context to the integration URL; the integration can then open a child (stacked) dialog with that trigger ID. See https://docs.mattermost.com/developer/interactive-dialogs.html for more information on interactive dialogs.

This request is always processed server-side. The client caps the number of simultaneously open interactive dialogs at 3, so if the resulting `open_dialog` event would exceed that limit the client silently skips rendering the additional dialog.

__Minimum server version: 11.10__

- Tags: integration_actions

## Parameters
No parameters.

## Request body
- required: True
- description: Dialog action button execution data
- content:
  - `application/json` -> object

## Responses
- `200`: Dialog action executed successfully
  - `application/json` -> object
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
