# Update channel member autotranslation setting

Original OpenAPI operationId: `UpdateChannelMemberAutotranslation`
- Method: `PUT`
- Path: `/api/v4/channels/{channel_id}/members/{user_id}/autotranslation`
- Summary: Update channel member autotranslation setting
- Description: Update a user's autotranslation setting for a channel. This controls whether messages in the channel should not be automatically translated for the user. By default, autotranslations are enabled for all users if the channel is enabled for autotranslation.
##### Permissions
Must be logged in as the user or have `edit_other_users` permission.

- Tags: channels

## Parameters
- `channel_id` (path, required, string) - Channel GUID
- `user_id` (path, required, string) - User GUID

## Request body
- required: True
- content:
  - `application/json` -> object

## Responses
- `200`: Channel member autotranslation setting update successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
