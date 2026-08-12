# Create a scheduled recap

Original OpenAPI operationId: `CreateScheduledRecap`
- Method: `POST`
- Path: `/api/v4/scheduled_recaps`
- Summary: Create a scheduled recap
- Description: Create a new scheduled recap configuration. Scheduled recaps run on a recurring or one-time schedule, generating AI-powered channel summaries at the configured time and day(s).
##### Permissions
Must be authenticated. The recap is created for the authenticated user.
__Minimum server version__: 11.2

- Tags: scheduled recaps, ai

## Parameters
No parameters.

## Request body
- required: True
- description: Scheduled recap configuration
- content:
  - `application/json` -> object

## Responses
- `201`: Scheduled recap created successfully
  - `application/json` -> ScheduledRecap
- `400`: No description available.
- `401`: No description available.
- `501`: No description available.
