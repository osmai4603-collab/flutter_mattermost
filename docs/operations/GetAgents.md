# Get available agents

Original OpenAPI operationId: `GetAgents`
- Method: `GET`
- Path: `/api/v4/agents`
- Summary: Get available agents
- Description: Retrieve all available agents from the plugin's bridge API. If a user ID is provided, only agents accessible to that user are returned.
##### Permissions
Must be authenticated.
__Minimum server version__: 11.2

- Tags: agents

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Agents retrieved successfully
  - `application/json` -> AgentsResponse
- `401`: No description available.
- `500`: No description available.
