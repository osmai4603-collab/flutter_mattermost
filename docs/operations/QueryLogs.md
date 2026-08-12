# Query server logs with filters

Original OpenAPI operationId: `QueryLogs`
- Method: `POST`
- Path: `/api/v4/logs/query`
- Summary: Query server logs with filters
- Description: Query server logs using filter criteria.
##### Permissions Must have `get_logs` permission.

- Tags: system

## Parameters
- `page` (query, optional, integer) - The page to select.
- `logs_per_page` (query, optional, string) - The number of logs per page.

## Request body
- required: True
- content:
  - `application/json` -> object

## Responses
- `200`: Log query successful
  - `application/json` -> object
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
