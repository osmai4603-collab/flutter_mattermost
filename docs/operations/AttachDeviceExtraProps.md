# Attach mobile device and extra props to the session object

Original OpenAPI operationId: `AttachDeviceExtraProps`
- Method: `PUT`
- Path: `/api/v4/users/sessions/device`
- Summary: Attach mobile device and extra props to the session object
- Description: Attach extra props to the session object of the currently logged in session.
Adding a mobile device id will enable push notifications for a user, if configured by the server.
Other props are also available, like whether the device has notifications disabled and the mobile version.
##### Permissions
Must be authenticated.

- Tags: users

## Parameters
No parameters.

## Request body
- required: True
- content:
  - `application/json` -> object

## Responses
- `200`: Device id attach successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
