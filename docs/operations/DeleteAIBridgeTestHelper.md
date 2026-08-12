# Reset AI bridge E2E test helper

Original OpenAPI operationId: `DeleteAIBridgeTestHelper`
- Method: `DELETE`
- Path: `/api/v4/system/e2e/ai_bridge`
- Summary: Reset AI bridge E2E test helper
- Description: Reset the in-memory AI bridge test helper state used for end-to-end tests.
This endpoint is only available when `EnableTesting` is enabled. `EnableTesting` is intended only for isolated non-production environments and must never be enabled in production.
##### Permissions
Must have `manage_system` permission.

- Tags: system

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: AI bridge test helper was reset successfully
  - `application/json` -> StatusOK
- `403`: No description available.
- `501`: No description available.
