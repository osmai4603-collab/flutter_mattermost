# Configure AI bridge E2E test helper

Original OpenAPI operationId: `SetAIBridgeTestHelper`
- Method: `PUT`
- Path: `/api/v4/system/e2e/ai_bridge`
- Summary: Configure AI bridge E2E test helper
- Description: Configure the in-memory AI bridge test helper used by end-to-end tests to mock agent availability, agent/service listings, queued completion responses, and test-only AI feature flag overrides.
This endpoint is only available when `EnableTesting` is enabled. `EnableTesting` is intended only for isolated non-production environments and must never be enabled in production.
##### Permissions
Must have `manage_system` permission.

- Tags: system

## Parameters
No parameters.

## Request body
- required: True
- description: AI bridge E2E helper configuration
- content:
  - `application/json` -> AIBridgeTestHelperConfig

## Responses
- `200`: AI bridge test helper configured successfully
  - `application/json` -> AIBridgeTestHelperState
- `400`: No description available.
- `403`: No description available.
- `501`: No description available.
