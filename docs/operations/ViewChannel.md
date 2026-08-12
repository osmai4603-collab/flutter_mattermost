# View channel

Original OpenAPI operationId: `ViewChannel`
- Method: `POST`
- Path: `/api/v4/channels/members/{user_id}/view`
- Summary: View channel
- Description: Perform all the actions involved in viewing a channel. This includes marking channels as read, clearing push notifications, and updating the active channel.
##### Permissions
Must be logged in as user or have `edit_other_users` permission.

__Response only includes `last_viewed_at_times` in Mattermost server 4.3 and newer.__

- Tags: channels

## Parameters
- `user_id` (path, required, string) - User ID to perform the view action for

## Request body
- required: True
- description: Paremeters affecting how and which channels to view
- content:
  - `application/json` -> object

## Responses
- `200`: Channel view successful
  - `application/json` -> object
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
