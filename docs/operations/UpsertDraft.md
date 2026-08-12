# Upsert synced draft

Original OpenAPI operationId: `UpsertDraft`
- Method: `POST`
- Path: `/api/v4/drafts`
- Summary: Upsert synced draft
- Description: Create or update a synced draft for the current user.
##### Permissions
Must be authenticated, have permission to create posts in the channel, and synced drafts must be enabled.

- Tags: users, drafts

## Parameters
No parameters.

## Request body
- required: True
- content:
  - `application/json` -> DraftUpsertRequest

## Responses
- `201`: Draft upsert successful. Returns `null` when an empty message deletes the draft.
  - `application/json` -> object
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
