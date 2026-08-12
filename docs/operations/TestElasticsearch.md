# Test Elasticsearch configuration

Original OpenAPI operationId: `TestElasticsearch`
- Method: `POST`
- Path: `/api/v4/elasticsearch/test`
- Summary: Test Elasticsearch configuration
- Description: Test the current Elasticsearch configuration to see if the Elasticsearch server can be contacted successfully.
Optionally provide a configuration in the request body to test. If no valid configuration is present in the
request body the current server configuration will be tested.

__Minimum server version__: 4.1
##### Permissions
Must have `manage_system` permission.

- Tags: elasticsearch

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Elasticsearch test successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `500`: No description available.
- `501`: No description available.
