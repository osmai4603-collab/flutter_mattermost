# Rewrite a message using AI

Original OpenAPI operationId: `RewriteMessage`
- Method: `POST`
- Path: `/api/v4/posts/rewrite`
- Summary: Rewrite a message using AI
- Description: Rewrite a message using AI based on the specified action. The message will be processed by an AI agent and returned in a rewritten form.
##### Permissions
Must be authenticated.
__Minimum server version__: 11.2

- Tags: posts

## Parameters
No parameters.

## Request body
- required: True
- description: Rewrite request object
- content:
  - `application/json` -> object

## Responses
- `200`: Message rewritten successfully
  - `application/json` -> object
- `400`: No description available.
- `401`: No description available.
- `500`: Internal server error
  - `application/json` -> AppError
