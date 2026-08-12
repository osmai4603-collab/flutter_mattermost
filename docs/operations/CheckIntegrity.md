# Perform a database integrity check

Original OpenAPI operationId: `CheckIntegrity`
- Method: `POST`
- Path: `/api/v4/integrity`
- Summary: Perform a database integrity check
- Description: Performs a database integrity check.


__Note__: This check may temporarily harm system performance.


__Minimum server version__: 5.28.0


__Local mode only__: This endpoint is only available through [local mode](https://docs.mattermost.com/administration/mmctl-cli-tool.html#local-mode).

- Tags: system

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Integrity check successful
  - `application/json` -> array of IntegrityCheckResult
