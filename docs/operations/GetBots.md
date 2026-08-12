# Get bots

Original OpenAPI operationId: `GetBots`
- Method: `GET`
- Path: `/api/v4/bots`
- Summary: Get bots
- Description: Get a page of a list of bots.
##### Permissions
Must have `read_bots` permission for bots you are managing, and `read_others_bots` permission for bots others are managing.
__Minimum server version__: 5.10

- Tags: bots

## Parameters
- `page` (query, optional, integer) - The page to select.
- `per_page` (query, optional, integer) - The number of users per page.
- `include_deleted` (query, optional, boolean) - If deleted bots should be returned.
- `only_orphaned` (query, optional, boolean) - When true, only orphaned bots will be returned. A bot is considered orphaned if its owner has been deactivated.

## Request body
No request body.

## Responses
- `200`: Bot page retrieval successful
  - `application/json` -> array of Bot
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
