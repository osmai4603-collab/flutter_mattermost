# Update the scheme-derived roles of a channel member.

Original OpenAPI operationId: `UpdateChannelMemberSchemeRoles`
- Method: `PUT`
- Path: `/api/v4/channels/{channel_id}/members/{user_id}/schemeRoles`
- Summary: Update the scheme-derived roles of a channel member.
- Description: Update a channel member's scheme_admin/scheme_user properties. Typically this should either be `scheme_admin=false, scheme_user=true` for ordinary channel member, or `scheme_admin=true, scheme_user=true` for a channel admin.
__Minimum server version__: 5.0
##### Permissions
Must be authenticated and have the `manage_channel_roles` permission.

- Tags: channels

## Parameters
- `channel_id` (path, required, string) - Channel GUID
- `user_id` (path, required, string) - User GUID

## Request body
- required: True
- description: Scheme properties.
- content:
  - `application/json` -> object

## Responses
- `200`: Channel member's scheme-derived roles updated successfully.
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
