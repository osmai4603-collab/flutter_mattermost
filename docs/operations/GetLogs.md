# Get logs

Original OpenAPI operationId: `GetLogs`
- Method: `GET`
- Path: `/api/v4/logs`
- Summary: Get logs
- Description: Get a page of server logs, selected with `page` and `logs_per_page` query parameters.
##### Permissions
Must have `manage_system` permission.

- Tags: system

## Parameters
- `page` (query, optional, integer) - The page to select.
- `logs_per_page` (query, optional, string) - The number of logs per page. There is a maximum limit of 10000 logs per page.

## Request body
No request body.

## Responses
- `200`: Logs retrieval successful
  - `application/json` -> array of string
- `403`: No description available.
