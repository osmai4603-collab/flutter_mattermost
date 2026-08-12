# Search all private and open type channels across all teams

Original OpenAPI operationId: `SearchAllChannels`
- Method: `POST`
- Path: `/api/v4/channels/search`
- Summary: Search all private and open type channels across all teams
- Description: Returns all private and open type channels where 'term' matches on the name, display name, or purpose of
the channel.

Configured 'default' channels (ex Town Square and Off-Topic) can be excluded from the results
with the `exclude_default_channels` boolean parameter.

Channels that are associated (via GroupChannel records) to a given group can be excluded from the results
with the `not_associated_to_group` parameter and a group id string.

- Tags: channels

## Parameters
- `system_console` (query, optional, boolean) - Is the request from system_console. If this is set to true, it filters channels by the logged in user.


## Request body
- required: True
- description: The search terms and logic to use in the search.
- content:
  - `application/json` -> object

## Responses
- `200`: Paginated channel response. (Note that the non-paginated response—returned if the request body does not contain both `page` and `per_page` fields—is a simple array of channels.)
  - `application/json` -> object
- `400`: No description available.
- `401`: No description available.
