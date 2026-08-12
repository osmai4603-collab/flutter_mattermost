# Get user IDs of known users

Original OpenAPI operationId: `GetKnownUsers`
- Method: `GET`
- Path: `/api/v4/users/known`
- Summary: Get user IDs of known users
- Description: Get the list of user IDs of users with any direct relationship with a
user. That means any user sharing any channel, including direct and
group channels.
##### Permissions
Must be authenticated.

__Minimum server version__: 5.23

- Tags: users

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Known users' IDs retrieval successful
  - `application/json` -> object
- `401`: No description available.
