# Login to Mattermost server

Original OpenAPI operationId: `Login`
- Method: `POST`
- Path: `/api/v4/users/login`
- Summary: Login to Mattermost server
- Description: ##### Permissions
No permission required

- Tags: users

## Parameters
No parameters.

## Request body
- required: True
- description: User authentication object
- content:
  - `application/json` -> object

## Responses
- `201`: User login successful
  - `application/json` -> User
- `400`: No description available.
- `403`: No description available.
