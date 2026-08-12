# Patch a user

Original OpenAPI operationId: `PatchUser`
- Method: `PUT`
- Path: `/api/v4/users/{user_id}/patch`
- Summary: Patch a user
- Description: Partially update a user by providing only the fields you want to update. Omitted fields will not be updated. The fields that can be updated are defined in the request body, all other provided fields will be ignored.
##### Permissions
Must be logged in as the user being updated or have the `edit_other_users` permission.

- Tags: users

## Parameters
- `user_id` (path, required, string) - User GUID

## Request body
- required: True
- description: User object that is to be updated
- content:
  - `application/json` -> object

## Responses
- `200`: User patch successful
  - `application/json` -> User
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
