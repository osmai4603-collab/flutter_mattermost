# Update a scheduled recap

Original OpenAPI operationId: `UpdateScheduledRecap`
- Method: `PUT`
- Path: `/api/v4/scheduled_recaps/{scheduled_recap_id}`
- Summary: Update a scheduled recap
- Description: Update a scheduled recap configuration. Only the user who owns the scheduled recap can update it. The `user_id` and `create_at` fields are preserved from the original and cannot be changed.
##### Permissions
Must be authenticated. Must own the scheduled recap.
__Minimum server version__: 11.2

- Tags: scheduled recaps, ai

## Parameters
- `scheduled_recap_id` (path, required, string) - Scheduled Recap GUID

## Request body
- required: True
- description: Updated scheduled recap configuration
- content:
  - `application/json` -> object

## Responses
- `200`: Scheduled recap updated successfully
  - `application/json` -> ScheduledRecap
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `501`: No description available.
