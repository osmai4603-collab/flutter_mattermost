# Records user action when they accept or decline custom terms of service

Original OpenAPI operationId: `RegisterTermsOfServiceAction`
- Method: `POST`
- Path: `/api/v4/users/{user_id}/terms_of_service`
- Summary: Records user action when they accept or decline custom terms of service
- Description: Records user action when they accept or decline custom terms of service. Records the action in audit table.
Updates user's last accepted terms of service ID if they accepted it.

__Minimum server version__: 5.4
##### Permissions
Must be logged in as the user being acted on.

- Tags: users, terms of service

## Parameters
- `user_id` (path, required, string) - User GUID

## Request body
- required: True
- description: terms of service details
- content:
  - `application/json` -> object

## Responses
- `200`: Terms of service action recorded successfully
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
