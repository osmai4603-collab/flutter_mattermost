# Auto-Login to Mattermost server using CWS token

Original OpenAPI operationId: `LoginByCwsToken`
- Method: `POST`
- Path: `/api/v4/users/login/cws`
- Summary: Auto-Login to Mattermost server using CWS token
- Description: CWS stands for Customer Web Server which is the cloud service used to manage cloud instances.
##### Permissions
A Cloud license is required

- Tags: users

## Parameters
No parameters.

## Request body
- required: True
- description: User authentication object
- content:
  - `application/json` -> object

## Responses
- `302`: Login successful, it'll redirect to login page to perform the autologin
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
