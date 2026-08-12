# Update a user

Original OpenAPI operationId: `UpdateUser`
- Method: `PUT`
- Path: `/api/v4/users/{user_id}`
- Summary: Update a user
- Description: Update a user by providing the user object. The fields that can be updated are defined in the request body, all other provided fields will be ignored. Any fields not included in the request body will be set to null or reverted to default values.
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
- `200`: User update successful
  - `application/json` -> User
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
