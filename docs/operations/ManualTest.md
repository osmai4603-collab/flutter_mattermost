# Run manual testing helpers

Original OpenAPI operationId: `ManualTest`
- Method: `GET`
- Path: `/manualtest`
- Summary: Run manual testing helpers
- Description: Invokes manual test helpers used by developers and automated manual test scenarios.
This endpoint is only registered when `ServiceSettings.EnableTesting` is enabled.

##### Permissions

None. Authentication is not required; this route uses the same handler stack as other unauthenticated API handlers (`APIHandler`).

__Security note:__ Only enable `EnableTesting` on non-production, developer-oriented deployments.

- Tags: system

## Parameters
- `test` (query, required, string) - Name of the manual test to run.
- `uid` (query, optional, string) - Optional unique value used to randomize generated resources.
- `username` (query, optional, string) - Optional username used for helper account creation.
- `teamname` (query, optional, string) - Optional team display name used for helper team creation.

## Request body
No request body.

## Responses
- `307`: Manual test setup completed and redirected to the default channel.
- `400`: No description available.
- `500`: No description available.
