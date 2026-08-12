# Create a channel recap

Original OpenAPI operationId: `CreateRecap`
- Method: `POST`
- Path: `/api/v4/recaps`
- Summary: Create a channel recap
- Description: Create a new AI-powered recap for the specified channels. The recap will summarize unread messages in the selected channels, extracting highlights and action items. This creates a background job that processes the recap asynchronously. The recap is created for the authenticated user.
##### Permissions
Must be authenticated. User must be a member of all specified channels.
__Minimum server version__: 11.2

- Tags: recaps, ai

## Parameters
No parameters.

## Request body
- required: True
- description: Recap creation request
- content:
  - `application/json` -> object

## Responses
- `201`: Recap creation successful. The recap will be processed asynchronously.
  - `application/json` -> Recap
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
