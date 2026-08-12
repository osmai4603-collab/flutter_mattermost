# Purge all Elasticsearch indexes

Original OpenAPI operationId: `PurgeElasticsearchIndexes`
- Method: `POST`
- Path: `/api/v4/elasticsearch/purge_indexes`
- Summary: Purge all Elasticsearch indexes
- Description: Deletes all Elasticsearch indexes and their contents. After calling this endpoint, it is
necessary to schedule a new Elasticsearch indexing job to repopulate the indexes.
__Minimum server version__: 4.1
##### Permissions
Must have `manage_system` permission.

- Tags: elasticsearch

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Indexes purged successfully.
  - `application/json` -> StatusOK
- `500`: No description available.
- `501`: No description available.
