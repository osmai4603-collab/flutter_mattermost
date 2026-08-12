# Create a board channel

Original OpenAPI operationId: `CreateBoard`
- Method: `POST`
- Path: `/api/v4/boards`
- Summary: Create a board channel
- Description: *__Experimental__: This endpoint is experimental and may change or be removed in a future release.*

Create a new board channel. Boards are channels with a kanban view backed
by linked properties (status and assignee by default), and live alongside
regular channels but cannot be created or modified through the
`/api/v4/channels` endpoints.

The request body is a `Channel` object whose `type` must be `BO`
(open board) or `BP` (private board). `team_id` and `display_name` are
required.

This endpoint is gated behind the `IntegratedBoards` feature flag. When
the flag is off, the route is not registered and requests return `404`.

##### Permissions
Must have `create_public_channel` for type `BO`, or
`create_private_channel` for type `BP`, on the target team.

- Tags: boards

## Parameters
No parameters.

## Request body
- required: True
- description: Board channel to be created
- content:
  - `application/json` -> object

## Responses
- `201`: Board channel creation successful
  - `application/json` -> Channel
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `500`: No description available.
