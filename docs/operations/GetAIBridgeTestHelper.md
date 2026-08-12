# Get AI bridge E2E test helper state

Original OpenAPI operationId: `GetAIBridgeTestHelper`
- Method: `GET`
- Path: `/api/v4/system/e2e/ai_bridge`
- Summary: Get AI bridge E2E test helper state
- Description: Retrieve the current in-memory AI bridge test helper state used for end-to-end tests.
This endpoint is only available when `EnableTesting` is enabled. `EnableTesting` is intended only for isolated non-production environments and must never be enabled in production.
##### Permissions
Must have `manage_system` permission.

- Tags: system

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: AI bridge test helper state retrieved successfully
  - `application/json` -> AIBridgeTestHelperState
- `403`: No description available.
- `501`: No description available.
