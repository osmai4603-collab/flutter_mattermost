# Get available LLM services

Original OpenAPI operationId: `GetLLMServices`
- Method: `GET`
- Path: `/api/v4/llmservices`
- Summary: Get available LLM services
- Description: Retrieve all available LLM services from the plugin's bridge API. If a user ID is provided, only services accessible to that user (via their permitted bots) are returned.
##### Permissions
Must be authenticated.
__Minimum server version__: 11.2

- Tags: agents

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: LLM services retrieved successfully
  - `application/json` -> ServicesResponse
- `401`: No description available.
- `500`: No description available.
