# Patch a channel

Original OpenAPI operationId: `PatchChannel`
- Method: `PUT`
- Path: `/api/v4/channels/{channel_id}/patch`
- Summary: Patch a channel
- Description: Partially update a channel by providing only the fields you want to update. Omitted fields will not be updated. At least one of the allowed fields must be provided.
**Public and private channels:** Can update `name`, `display_name`, `purpose`, `header`, `group_constrained`, `autotranslation`, and `banner_info` (subject to permissions and channel type).
**Direct and group message channels:** Only `header` and (when not restricted by config) `autotranslation` can be updated; the caller must be a channel member. Updating `name`, `display_name`, or `purpose` is not allowed.
The default channel (e.g. Town Square) cannot have its `name` changed.
##### Permissions
- **Public channel:** For property updates (name, display_name, purpose, header, group_constrained), `manage_public_channel_properties` is required. For `autotranslation`, `manage_public_channel_auto_translation` is required. For `banner_info`, `manage_public_channel_banner` is required (Channel Banner feature and Enterprise license required). - **Private channel:** For property updates, `manage_private_channel_properties` is required. For `autotranslation`, `manage_private_channel_auto_translation` is required. For `banner_info`, `manage_private_channel_banner` is required (Channel Banner feature and Enterprise license required). - **Direct or group message channel:** Must be a member of the channel; only `header` and (when allowed) `autotranslation` can be updated.

- Tags: channels

## Parameters
- `channel_id` (path, required, string) - Channel ID

## Request body
- required: True
- description: Channel patch object; include only the fields to update. At least one field must be provided.
- content:
  - `application/json` -> object

## Responses
- `200`: Channel patch successful
  - `application/json` -> Channel
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
