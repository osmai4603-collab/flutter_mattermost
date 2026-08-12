# Report client performance metrics

Original OpenAPI operationId: `SubmitPerformanceReport`
- Method: `POST`
- Path: `/api/v4/client_perf`
- Summary: Report client performance metrics
- Description: Uploads client performance measurements to the server as part of the Client Performance Monitoring feature.
__Minimum server version__: 9.9.0

- Tags: metrics

## Parameters
No parameters.

## Request body
- required: False
- content:
  - `application/json` -> object

## Responses
- `200`: Measurements reported successfully
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
