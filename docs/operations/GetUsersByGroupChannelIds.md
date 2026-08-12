# Get users by group channels ids

Original OpenAPI operationId: `GetUsersByGroupChannelIds`
- Method: `POST`
- Path: `/api/v4/users/group_channels`
- Summary: Get users by group channels ids
- Description: Get an object containing a key per group channel id in the
query and its value as a list of users members of that group
channel.

The user must be a member of the group ids in the query, or
they will be omitted from the response.
##### Permissions
Requires an active session but no other permissions.

__Minimum server version__: 5.14

- Tags: users

## Parameters
No parameters.

## Request body
- required: True
- description: List of group channel ids
- content:
  - `application/json` -> array of string

## Responses
- `200`: User list retrieval successful
  - `application/json` -> object
- `400`: No description available.
- `401`: No description available.
