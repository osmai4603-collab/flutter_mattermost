# Get agents bridge status

Original OpenAPI operationId: `GetAgentsStatus`
- Method: `GET`
- Path: `/api/v4/agents/status`
- Summary: Get agents bridge status
- Description: Retrieve the status of the AI plugin bridge. Returns availability boolean and a reason code if unavailable.
##### Permissions
Must be authenticated.
__Minimum server version__: 11.2

- Tags: agents

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Status retrieved successfully
  - `application/json` -> AgentsIntegrityResponse
- `401`: No description available.
- `500`: No description available.
