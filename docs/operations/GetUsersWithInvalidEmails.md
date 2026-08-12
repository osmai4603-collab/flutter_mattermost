# Get users with invalid emails

Original OpenAPI operationId: `GetUsersWithInvalidEmails`
- Method: `GET`
- Path: `/api/v4/users/invalid_emails`
- Summary: Get users with invalid emails
- Description: Get users whose emails are considered invalid.
It is an error to invoke this API if your team settings enable an open server.
##### Permissions
Requires `sysconsole_read_user_management_users`.

- Tags: users

## Parameters
- `page` (query, optional, integer) - The page to select.
- `per_page` (query, optional, integer) - The number of users per page.

## Request body
No request body.

## Responses
- `200`: User page retrieval successful
  - `application/json` -> array of User
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
