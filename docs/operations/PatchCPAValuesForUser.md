# Update custom profile attribute values for a user

Original OpenAPI operationId: `PatchCPAValuesForUser`
- Method: `PATCH`
- Path: `/api/v4/users/{user_id}/custom_profile_attributes`
- Summary: Update custom profile attribute values for a user
- Description: Update Custom Profile Attribute field values for a specific user.

**Note:** Values for fields with `attrs.protected = true` cannot be
updated and will return an error.

__Minimum server version__: 11

##### Permissions
Must have permission to edit the user. Users can only edit their own CPA values unless they are system administrators.

- Tags: custom profile attributes

## Parameters
- `user_id` (path, required, string) - User GUID

## Request body
- required: True
- description: Custom Profile Attribute values that are to be updated
- content:
  - `application/json` -> array of object

## Responses
- `200`: Custom profile attribute values updated successfully
  - `application/json` -> array of object
- `400`: No description available.
- `403`: No description available.
- `404`: No description available.
