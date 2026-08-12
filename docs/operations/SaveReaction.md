# Create a reaction

Original OpenAPI operationId: `SaveReaction`
- Method: `POST`
- Path: `/api/v4/reactions`
- Summary: Create a reaction
- Description: Create a reaction.
##### Permissions
Must have `read_channel` permission for the channel the post is in.

- Tags: reactions

## Parameters
No parameters.

## Request body
- required: True
- description: The user's reaction with its post_id, user_id, and emoji_name fields set
- content:
  - `application/json` -> Reaction

## Responses
- `201`: Reaction creation successful
  - `application/json` -> Reaction
- `400`: No description available.
- `403`: No description available.
